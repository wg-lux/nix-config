{ 
  config, pkgs, lib, inputs, 
  agl-network-config, custom-hardware-config,
  hostname, ip,
  ... 
}: 

let
  hostname = config.networking.hostName;
  openvpn-config = agl-network-config.services.openvpn;
  network-interface = agl-network-config.hardware.${hostname}.network-interface;

in
{
  # asd 
  imports = [
    # Users
    (import ./users.nix { inherit config pkgs inputs agl-network-config openvpn-config; })
    (import ./groups.nix { inherit openvpn-config; })
    (import ./secrets.nix {
      inherit config;
    })
    
    # Console Environment
    ./zsh.nix

    # Custom Config Files
    (import ./etc/main.nix {
      inherit config pkgs agl-network-config;
    })

    # base services
    ../../services/firewall.nix
    ../../services/sops.nix
    ../../services/ssh.nix
    ./direnv.nix

    # Custom Loggers
    ( import ./custom-logs.nix {
      inherit config pkgs lib agl-network-config;
    })
    
    # Network Services
    (import ./wake-on-lan.nix {inherit network-interface;})
    
    ## OpenVPN
    (import ../../services/openvpn.nix {
      inherit pkgs config lib;
      inherit openvpn-config;
    })
    (import ../../services/openvpn-host.nix {
      inherit pkgs config lib;
      inherit openvpn-config;
    })
    
    ./power-settings.nix

    (import ../../services/garbage-collector.nix {inherit config pkgs;})

    # UI
    (import ./xserver.nix {inherit pkgs; } )
    ./fonts.nix

    # Other Packages
    ./vscode.nix
    (import ./system-packages.nix {inherit config pkgs;})

    # Utility Scripts
    ../../scripts/util-scripts.nix

    # Misc
    ./locale-settings.nix
    ./printer.nix
    ./audio.nix
  ];

}
