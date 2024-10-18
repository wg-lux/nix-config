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

  imports = [
    (
      import ../endoreg-clients/base.nix {
        inherit config pkgs lib;
        inherit custom-hardware-config ip hostname agl-network-config;
      }
    )

    # Auto Decrypt Hdd on Dev Machine
    (import ../endoreg-clients/luks-base-decrypt.nix { inherit config custom-hardware-config; })

    ( import ../shared/local-nginx.nix { 
      inherit agl-network-config config;
    })

    (
      import ../shared/nfs-share.nix {
        inherit pkgs;
        inherit agl-network-config;
      } 
    )
  ];

  ###### DEV FOR AGL MONITOR ######

  services.nginx.virtualHosts = {
    "monitor.local" = {
        locations."/" = {
        proxyPass = "http://127.0.0.1:9999";
        };
    };
  };

  networking.extraHosts = ''
    127.0.0.1 monitor.local
  '';

  #################################
  


  system.stateVersion = "23.11";

}
