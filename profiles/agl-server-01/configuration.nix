{ 
  inputs, config, pkgs, lib,
  custom-hardware-config, ip, hostname, agl-network-config,
  ... }:
let 
  network-interface = custom-hardware-config.network-interface;

in
{
  imports =
    [
      ( import ../../services/dnsmasq.nix {inherit pkgs agl-network-config;} )

      ../../services/utils/scheduled-reboot-nightly.nix
    ];

  system.stateVersion = "23.11";

}
