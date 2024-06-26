{ 
  inputs, 
  config, 
  pkgs, 
  lib,
  agl-server-01-ip,
  agl-network-config,
  openvpnCertPath,
  openvpnConfigPath,
  ... }:
let
  hostname = "agl-server-01";
  network_interface = "enp1s0";
  ip = agl-server-01-ip;

in  
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages.nix
      ( import ../../services/dnsmasq.nix {inherit pkgs network_interface;} )
      ( import ./secrets.nix {
          inherit config openvpnCertPath openvpnConfigPath;
      })
      ( import ../base/configuration.nix { 
          inherit config pkgs lib inputs; 
          inherit network_interface openvpnCertPath openvpnConfigPath; 
          inherit hostname;
      })
      # ../../services/bind.nix
    ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  system.stateVersion = "23.11";

}
