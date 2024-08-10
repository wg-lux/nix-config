# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ 
  inputs, config, pkgs,
  lib,
  openvpnCertPath,
  agl-network-config,
  base-profile-settings,
  ...
}:
let
  hostname = "agl-server-03";
  network_interface = "enp2s0";

in  
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./git.nix
      ( import ../base/configuration.nix { 
        inherit config pkgs lib inputs network_interface;
        inherit openvpnCertPath hostname; 
        inherit base-profile-settings;
         })
      ( import ../../services/keycloak.nix { inherit config pkgs; })
      (import ../../services/main_nginx.nix {
        inherit pkgs;
        inherit agl-network-config;
      })
      ( import ../shared/nfs-share.nix {
        inherit pkgs;
        inherit agl-network-config;
        # inherit agl-nas-02-ip nfs-share-all-local-path nfs-share-all-mount-path; 
      } )

      ../../services/utils/scheduled-reboot-nightly.nix
    ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  system.stateVersion = "23.11";

}
