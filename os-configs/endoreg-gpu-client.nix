{
    nixpkgs, pkgs,
    base-config,
    hostname, inputs, 
    agl-network-config,
    extra-modules, custom-services,
    ...
}@args:

let
    system = base-config.system;

    sops-nix = extra-modules.sops-nix;
    vscode-server = extra-modules.vsconde-server;

    agl-monitor = custom-services.monitor;
    endoreg-client-manager = custom-services.client-manager;

    
in
nixpkgs.lib.nixosSystem {
    system = system;

    specialArgs = {
        hostname = hostname;
        inherit inputs system; 
        inherit agl-network-config;
        
    };
    
    modules = [
        ../profiles/main.nix
        
        endoreg-client-manager.nixosModules.endoreg-client-manager
        endoreg-client-manager.nixosModules.agl-anonymizer
        agl-monitor.nixosModules.agl-monitor


        sops-nix.nixosModules.sops
        
        ## The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
        ## to not collide with the nixpkgs version.
        # nix-ld.nixosModules.nix-ld
        # { programs.nix-ld.dev.enable = true; }

        vscode-server.nixosModules.default 
        ({config, pkgs, ... }: {
            services.vscode-server.enable = true;
        })
    ];
}