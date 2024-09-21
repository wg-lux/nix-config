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
      # openvpn-host service is imported in the base/configuration.nix file
      ( import ../../services/dnsmasq.nix {inherit pkgs agl-network-config;} )

      ../../services/utils/scheduled-reboot-nightly.nix
    ];

  system.stateVersion = "23.11";

}
