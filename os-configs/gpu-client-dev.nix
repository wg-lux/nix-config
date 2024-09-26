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
    agl-anonymizer = custom-services.agl-anonymizer;

    
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
        # endoreg-client-manager.nixosModules.agl-anonymizer
        agl-monitor.nixosModules.agl-monitor
        agl-anonymizer.nixosModules.agl-anonymizer

        # Custom vscode override
        sops-nix.nixosModules.sops
        vscode-server.nixosModules.default 

        # Set custom nix config settings
        ({config, pkgs, ... }: {
            services.vscode-server.enable = true;
        })
    ];
}