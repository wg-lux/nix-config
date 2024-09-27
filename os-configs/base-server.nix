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
        # custom-services.agl-monitor.nixosModules.agl-monitor

        # Custom vscode override
        sops-nix.nixosModules.sops
        vscode-server.nixosModules.default 

        # Set custom nix config settings
        ({config, pkgs, ... }: {
            services.vscode-server.enable = true;
        })
    ];
}