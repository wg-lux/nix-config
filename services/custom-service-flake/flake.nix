{
  description = "A flake providing a custom service with cuda environment";

  inputs = {

    # inputs.systems.url = "github:nix-systems/x86_64-linux";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # flake-utils.url = "github:numtide/flake-utils";
    # inputs.flake-utils.inputs.systems.follows = "systems";

    cachix = {
        url = "github:cachix/cachix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };



  outputs = { self, nixpkgs, flake-utils, cachix, ... }:
    let 
      system = "x86_64-linux";
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
          pythonFilePath = lib.mkOption {
            type = lib.types.str;
            default = "/home/agl-admin/nix-config/services/custom-service-flake/my-service.py";
            description = "Path to the python file.";
          };
        };

        config = lib.mkIf config.services.myCustomService.enable {
          systemd.services.myCustomService = {
            description = "My Custom Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            script = let
              pythonEnv = self.packages.pythonWithPytorch;
            in ''
              ${pythonEnv}/bin/python ${config.services.myCustomService.pythonFilePath} > ${config.services.myCustomService.path}
            '';
          };
        };
      };

    };
}
