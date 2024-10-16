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

      ( import ../shared/local-nginx.nix { 
        inherit agl-network-config config;
      })
      
      ../../services/utils/scheduled-reboot-nightly.nix
    ];


  #TODO How to use multiple network interfaces? 
  # Preferably one for external communication and a dedicated one for local communication
  # networking.defaultGateway = {
  #   interface = custom-hardware-config.network-interface;

  # };

  system.stateVersion = "23.11";

}
