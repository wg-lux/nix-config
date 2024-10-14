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
    custom-packages = args.custom-packages;

    ##### MIGRATE AFTER TESTING

    #####
    
in
nixpkgs.lib.nixosSystem {
    system = system;

    specialArgs = {
        hostname = hostname;
        inherit inputs system; 
        inherit agl-network-config;
        
    };

    ###### MIGRATE AFTER TESTING

    # services.agl-anonymizer = agl-network-config.services.agl-anonymizer;
    # services.agl-anonymizer = {
    #     enable = true;
    # };

    ############################
    
    modules = [
        ../profiles/main.nix
        custom-services.agl-monitor.nixosModules.agl-monitor
        custom-packages.endoreg-usb-encrypter.nixosModules.encrypter
        custom-services.agl-anonymizer.nixosModules.agl-anonymizer
        # Custom vscode override
        sops-nix.nixosModules.sops
        vscode-server.nixosModules.default 

        # Set custom nix config settings
        ({config, pkgs, ... }: {
            services.vscode-server.enable = true;
        })
    ];
}