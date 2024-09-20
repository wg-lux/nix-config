{ config, pkgs, lib,
  custom-hardware-config, ip, hostname, agl-network-config,
  ... 
}:
let
  hostname = config.networking.hostName;
  ip = agl-network-config.ips.${hostname};
  endoreg-client-manager-config = agl-network-config.endoreg-client-manager-config;
  endoreg-client-manager-path = endoreg-client-manager-config.path;

  network-interface = custom-hardware-config.network-interface;
  nvidiaBusId = custom-hardware-config.nvidiaBusId;
  onboardGraphicBusId = custom-hardware-config.onboardGraphicBusId;

in  
{ #
  imports =
    [ # Hardware
        ./hardware-acceleration.nix
        ../shared/touchpad.nix
        ./packages.nix

        (
            import ../../services/agl-monitor/main.nix {
                inherit config pkgs lib;
                inherit agl-network-config;
            }
        )

        (import ./luks-devices.nix { inherit config custom-hardware-config; })

        (import ../shared/nvidia.nix { inherit config pkgs nvidiaBusId onboardGraphicBusId; })
        (import ../shared/obsidian.nix { inherit pkgs ; })
        (import ../shared/ffmpeg.nix { inherit pkgs ; })
        (import ../shared/opencv.nix { inherit pkgs ; })

        # Custom Services
        (
            import ./secrets.nix {
                inherit config hostname endoreg-client-manager-path;
            } 
        )

        (
            import ../../services/endoreg-client/main.nix {
                inherit config pkgs lib; 
                inherit endoreg-client-manager-config;
            } 
        )
      
    ];

  system.stateVersion = "23.11";

}
