# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib,
  network_interface, ip,
  openvpnCertPath,
  nvidiaBusId, onboardGraphicBusId,
  agl-home-django-package, #TODO CHECK IF STILL NEEDED
  endoreg-client-manager-config,
  base-profile-settings,
  agl-nas-02-ip, nfs-share-all-local-path, nfs-share-all-mount-path,
  agl-network-config,
  
  ... }:
let
  hostname = "agl-gpu-client-02";
  testy = agl-network-config.services.nfs-share.ip;
  endoreg-client-manager-path = endoreg-client-manager-config.path;
in  
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hardware-acceleration.nix
      ../shared/touchpad.nix

      ( 
        import ./local-monitoring/local-monitoring.nix {
          inherit pkgs config ip;
          inherit agl-network-config;
        } 
      )
      ( import ./packages.nix {
         inherit config pkgs lib ; 
        })
      ( import ../shared/local-nginx.nix { 
        inherit agl-network-config;
       } )
      (import ../shared/nvidia.nix { inherit config pkgs nvidiaBusId onboardGraphicBusId; })
      (import ../shared/obsidian.nix { inherit pkgs ; })
      (import ../shared/ffmpeg.nix { inherit pkgs ; })
      (import ../shared/opencv.nix { inherit pkgs ; })
      (import ../shared/docker.nix { inherit pkgs ; })
      (import ../shared/wireless-config.nix { inherit pkgs ; })
      
      # ./wireguard.nix
      ( import ../base/configuration.nix { 
        inherit config pkgs lib inputs network_interface; 
        inherit hostname openvpnCertPath; 
        inherit base-profile-settings;
        users-mutable = true;
        })
      (import ../shared/python/main.nix { inherit pkgs; })

      # Custom Services
      (import ../endoreg-clients/secrets.nix {
          inherit config hostname;
          endoRegClientManagerPath = endoreg-client-manager-path ;

        } 
      )
      (
        import ../../services/endoreg-client/main.nix {
            inherit config pkgs lib; 
            inherit endoreg-client-manager-config;
          } 
        )
      ];
  
  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "8192";
  }];

  security.polkit.enable = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  hardware.acpilight.enable = true;

  system.stateVersion = "23.11";

}
