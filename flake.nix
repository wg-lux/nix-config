{
  description = "AGL Nix Config";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

    agl-anonymizer.url = "github:wg-lux/agl-anonymizer-flake";
    agl-anonymizer.inputs.nixpkgs.follows = "nixpkgs";
    
    monitor-flake.url = "github:wg-lux/agl-monitor-flake";
    monitor-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-index-database, vscode-server, sops-nix, ... }@inputs: let
    base-config = {
      system = "x86_64-linux";
      allow-unfree = true;
      cuda-support = true;
    };

    system = base-config.system;
    pkgs = import nixpkgs {
      system = system;
      config = {
        allowUnfree = base-config.allow-unfree;
        cudaSupport = base-config.cuda-support;
      };
    };

    agl-network-config = import ./network-configuration/main.nix;
    hostnames = agl-network-config.hostnames;

    custom-services = {
      agl-monitor = inputs.monitor-flake;
      agl-anonymizer = inputs.agl-anonymizer;
    };

    extra-modules = {
      sops-nix = sops-nix;
      vscode-server = vscode-server;
      nix-ld = inputs.nix-ld;
    };

    os-base-args = {
      nixpkgs = nixpkgs;
      pkgs = pkgs;
      base-config = base-config;
      inputs = inputs;
      agl-network-config = agl-network-config;
      extra-modules = extra-modules;
      custom-services = custom-services;
      hostnames = hostnames;
    };

    _os-configurations = import ./os-configs/main.nix (
      {
        os-base-args = os-base-args;
        agl-network-config = agl-network-config;
        extra-modules = extra-modules;
        custom-services = custom-services;
      }
    );
    
    os-configurations = _os-configurations.os-configs;
  
  in {
    nixosConfigurations = os-configurations;

    nixosConfigurations."your-system" = nixpkgs.lib.nixosSystem {
      system = base-config.system;
      
      modules = [
        # Enable Docker service
        { config, pkgs, ... }: {
          virtualisation.docker.enable = true;

          # Add your user to the docker group for access
          users.users.agl-admin.extraGroups = [ "docker" ];

          # Optionally enable Docker rootless mode
          # virtualisation.docker.rootless.enable = true;

          # Optionally configure Docker daemon settings
          # virtualisation.docker.daemon.settings = {
          #   data-root = "/var/lib/docker";
          #   userland-proxy = false;
          #   experimental = true;
          #   metrics-addr = "0.0.0.0:9323";
          #   ipv6 = true;
          #   fixed-cidr-v6 = "fd00::/80";
          # };
        }

        # Import custom services and modules
        ./services/docker.nix
        ./profiles/main.nix
        custom-services.agl-monitor.nixosModules.agl-monitor
        sops-nix.nixosModules.sops
        vscode-server.nixosModules.default
        ({ config, pkgs, ... }: {
          services.vscode-server.enable = true;
        })
      ];
    };
  };
}
