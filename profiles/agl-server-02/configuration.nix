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

  system.stateVersion = "23.11";

}
