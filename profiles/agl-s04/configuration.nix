# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ 
  inputs, 
  config, 
  pkgs,
  openvpnCertPath,
  lib,
  agl-server-04-ip, 
  agl-network-config,
  # endoRegHomeIP, endoRegHomePort, endoRegHomePath, 
  # grafanaIP, grafanaPort,
  ... }:
let
  hostname = "agl-server-04";
  network_interface = "eno1";
  ip = agl-server-04-ip;

in  
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ( import ./packages.nix { inherit pkgs; })
      ( import ../base/configuration.nix { 
        inherit config pkgs lib inputs network_interface; 
        inherit openvpnCertPath hostname; 
        })
      ../../services/postgresql.nix
      # ../../services/main_nginx.nix
      ( import ../../services/agl_home_django.nix { 
        inherit config pkgs;
        inherit agl-network-config;
        # inherit endoRegHomeIP endoRegHomePort endoRegHomePath;  
      })
      ( import ../../services/grafana.nix {
        inherit config pkgs;
        inherit agl-network-config;
        # inherit grafanaIP grafanaPort; 
      })
    ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  system.stateVersion = "23.11";

}
