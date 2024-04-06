{ config, pkgs, ... }: {
  networking.firewall.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];
}