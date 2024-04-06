{
  description = "A flake providing a custom service with PyTorch CUDA environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    cachix = {
      url = "github:cachix/cachix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, cachix, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # Allow unfree packages if necessary for CUDA, etc.
        config.cudaSupport = true; 
      };
      nvidiaCache = cachix.lib.mkCachixCache {
        inherit (pkgs) lib;
        name = "nvidia";
        publicKey = "nvidia.cachix.org-1:dSyZxI8geDCJrwgvBfPH3zHMC+PO6y/BT7O6zLBOv0w=";
        secretKey = null; # not needed for pulling from the cache
      };
    in {
      packages.pythonWithPytorch = pkgs.python3.withPackages (ps: with ps; [
        numpy
        pandas
        pkgs.python3Packages.pytorchWithCuda
        pkgs.cudaPackages.cudnn
        pkgs.cudaPackages.cudatoolkit
      ]);

      nixConfig = {
        binary-caches = [nvidiaCache.binaryCachePublicUrl];
        binary-cache-public-keys = [nvidiaCache.publicKey];
      };

      nixosModules.custom-service = { lib, config, pkgs, nvidiaCache, ... }: {
        options.services.myCustomService = {
          enable = lib.mkEnableOption "My custom service";
          path = lib.mkOption {
            type = lib.types.str;
            default = "/home/agl-admin/my-service.log";
            description = "Path to the log file.";
          };
        };

        config = lib.mkIf config.services.myCustomService.enable {
          systemd.services.myCustomService = {
            description = "My Custom Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            script = let
              pythonEnv = self.packages.${system}.pythonWithPytorch;
            in ''
              ${pythonEnv}/bin/python -c 'import time; with open("${config.services.myCustomService.path}", "a") as f: f.write(f"Service run at {time.ctime()}\n")'
            '';
          };
        };
      };
    }
  );
}
