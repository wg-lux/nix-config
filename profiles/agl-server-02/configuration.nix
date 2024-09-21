{ 
  inputs, config, pkgs, lib,
  custom-hardware-config, ip, hostname, agl-network-config,
  ... }:
{
  imports =
    [ 
      ( import ../../services/nextcloud.nix {
        inherit config pkgs;
        inherit agl-network-config;
      })
      
      ../../services/utils/scheduled-reboot-nightly.nix
    ];

  ##### CUSTOM HARDWARE CONFIGURATION #####

  networking.interfaces.eno1.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;

  system.stateVersion = "23.11";

}
