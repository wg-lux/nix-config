{ 
  inputs, config, pkgs, lib,
  custom-hardware-config, ip, hostname, agl-network-config,
  ... }:
{
  imports =
    [
      ( import ../../services/keycloak.nix { inherit config pkgs; })
      ( import ../../services/main_nginx.nix {
        inherit pkgs;
        inherit agl-network-config;
      })
      ( import ../shared/nfs-share.nix {
        inherit pkgs;
        inherit agl-network-config;
      } )

      ../../services/utils/scheduled-reboot-nightly.nix
    ];

  system.stateVersion = "23.11";

}
