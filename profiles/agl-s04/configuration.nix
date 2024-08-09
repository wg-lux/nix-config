{ 
  inputs, 
  config, 
  pkgs,
  openvpnCertPath,
  lib,
  agl-server-04-ip, 
  agl-network-config,
  base-profile-settings,
  ... }:
let
  hostname = "agl-server-04";
  network_interface = "eno1";
  ip = agl-server-04-ip;

in  
{
  imports =
    [
      ./hardware-configuration.nix
      ( import ./packages.nix { inherit pkgs; })
      ( import ../base/configuration.nix { 
        inherit config pkgs lib inputs network_interface; 
        inherit openvpnCertPath hostname; 
        inherit base-profile-settings;
        })
      ../../services/postgresql.nix
      ( import ../../services/agl_home_django.nix { 
        inherit config pkgs;
        inherit agl-network-config;
      })
      ( import ../../services/grafana.nix {
        inherit config pkgs;
        inherit agl-network-config;
      })

      ../../services/utils/scheduled-reboot-nightly.nix
    ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  system.stateVersion = "23.11";

}
