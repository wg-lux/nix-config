{ inputs, config, pkgs, lib,
  custom-hardware-config, ip, hostname, agl-network-config,
  ... 
}:
let
  ip = agl-network-config.ips.${hostname};
  endoreg-client-manager-config = agl-network-config.endoreg-client-manager-config;
  endoreg-client-manager-path = endoreg-client-manager-config.path;

  network-interface = custom-hardware-config.network-interface;
  nvidiaBusId = custom-hardware-config.nvidiaBusId;
  onboardGraphicBusId = custom-hardware-config.onboardGraphicBusId;

in  
{
  imports =
    [
      (
        import ../endoreg-clients/base.nix {
          inherit config pkgs lib;
          inherit custom-hardware-config ip hostname agl-network-config;
        }
      )

      # Custom Loggers
      (
        import ../../scripts/logging/check-openvpn.nix {
          inherit config pkgs lib agl-network-config;
        }
      )

      # Auto Decrypt Hdd on Dev Machine
      (import ../endoreg-clients/luks-base-decrypt.nix { inherit config custom-hardware-config; })

      # Networking
      # ./wpa_supplicant.nix

      # ( 
      #   import ./local-monitoring/local-monitoring.nix {
      #     inherit pkgs config ip;
      #     inherit agl-network-config;
      #   } 
      # )
      
      ( import ../shared/local-nginx.nix { 
        inherit agl-network-config;
      })

      (
        import ../shared/nfs-share.nix {
          inherit pkgs;
          inherit agl-network-config;
        } 
      )
      
    ];

  system.stateVersion = "23.11";

}
