{ 
  inputs, config, pkgs, lib,
  custom-hardware-config, ip, hostname, agl-network-config,
  ... }:

let 
  stateVersion = "CHANGE MANUALLY FROM SYSTEMS ORIGINALLY CREATED CONFIG";

in
{
  imports =
    [ 
      ( import ../../services/nextcloud.nix {
        inherit config pkgs;
        inherit agl-network-config;
      })
      
    ];

  ##### CUSTOM HARDWARE CONFIGURATION #####

  system.stateVersion = stateVersion;

}
