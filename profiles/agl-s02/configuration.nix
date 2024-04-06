# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:
let
  hostname = "agl-server-02";
  network_interface = "enp1s0"; # is ethernet ; wlp2s0 is wlan

in  
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users.nix
      # ./wireguard.nix
      ( import ../base/configuration.nix { 
        inherit config pkgs lib inputs network_interface;
        inherit openvpnCertPath hostname; 
        
         })
      ../../services/grafana.nix
    ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  system.stateVersion = "23.11";

}
