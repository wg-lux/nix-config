{
    nixpkgs, pkgs,
    base-config,
    hostname, inputs, 
    agl-network-config,
    extra-modules, custom-services,
    ...
}@args:

let

    ######### EXPERIMENTAL
    clangVersion = "16";   # Version of Clang
    gccVersion = "13";     # Version of GCC
    llvmPkgs = pkgs."llvmPackages_${clangVersion}";  # LLVM toolchain
    gccPkg = pkgs."gcc${gccVersion}";  # GCC package for compiling

    # Create a clang toolchain with libstdc++ from GCC
    clangStdEnv = pkgs.stdenvAdapters.overrideCC llvmPkgs.stdenv (llvmPkgs.clang.override {
      gccForLibs = gccPkg;  # Link Clang with libstdc++ from GCC
    });

    ################################################

    system = base-config.system;

    sops-nix = extra-modules.sops-nix;
    vscode-server = extra-modules.vsconde-server;
    custom-packages = args.custom-packages;
    
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
        # custom-packages.endoreg-usb-encrypter.nixosModules.encrypter
        # custom-services.agl-anonymizer.nixosModules.agl-anonymizer
        # Custom vscode override
        sops-nix.nixosModules.sops
        vscode-server.nixosModules.default 

        # Set custom nix config settings
        ({config, pkgs, ... }: {
            services.vscode-server.enable = true;
        })
    ];
}