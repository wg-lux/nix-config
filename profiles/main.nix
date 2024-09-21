{ inputs, config, pkgs, lib,
  hostname, agl-network-config, 
  ... 
}:
let
    ip = agl-network-config.ips.${hostname};
    custom-hardware-config = agl-network-config.hardware.${hostname};
    endoreg-client-manager-config = agl-network-config.endoreg-client-manager-config;

    custom-config-path = builtins.toPath ./${hostname}/configuration.nix;
    custom-hardware-path = builtins.toPath ./${hostname}/hardware-configuration.nix;
    custom-packages-path = builtins.toPath ./${hostname}/packages.nix;
    custom-git-path = builtins.toPath ./${hostname}/git.nix;

in  
{
    security.polkit.enable = true;

    networking.hostName = hostname;
    networking.networkmanager.enable = true;
    
    imports = [  
        ../services/ssh.nix 
        (import ./shared/python/main.nix { inherit pkgs; })
        (import ./shared/wireless-config.nix { inherit pkgs ; })

        custom-hardware-path
        custom-packages-path
        custom-git-path

        ( import custom-config-path {
            inherit inputs config pkgs lib;
            inherit hostname ip custom-hardware-config agl-network-config;
        })
        
        ( import custom-packages-path {
            inherit config pkgs lib ; 
        })
        
        ( import ./base/configuration.nix { 
            inherit config pkgs lib inputs;
            inherit hostname ip;
            inherit agl-network-config custom-hardware-config; 
            users-mutable = true;
        })
    ];

    security.pam.loginLimits = [{
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "8192";
    }];

    nixpkgs.config.allowUnfree = true;

    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
    };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_6_10;

    programs.git = {
        enable = true;
    };

}
