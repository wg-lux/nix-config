{ 
  inputs, config, pkgs, lib,
  custom-hardware-config, ip, hostname, agl-network-config,
  ... }:
let 
  agl-home-django-config = agl-network-config.services.agl-home-django;

in
{
  imports =
    [
      ../../services/postgresql.nix
      ( import ../../services/agl-home-django/main.nix { 
        inherit config pkgs lib;
        inherit agl-home-django-config agl-network-config;
      })

      ../../services/utils/scheduled-reboot-nightly.nix
    ];

  system.stateVersion = "23.11";

}
