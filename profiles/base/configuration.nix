{ 
  config, pkgs, lib, inputs, 
  agl-network-config, custom-hardware-config,
  hostname, ip,
  ... 
}: 

let
  openvpn-config-path = agl-network-config.paths.openvpn-config-path;
  openvpn-cert-path = agl-network-config.paths.openvpn-cert-path;
  network-interface = custom-hardware-config.network-interface;

in
{
  # asd 
  imports = [
    # Users
    (import ./users.nix { inherit hostname config pkgs inputs openvpn-cert-path; })
    
    # Console Environment
    ./zsh.nix

    # Custom Config Files
    ./etc.nix

    # base services
    ../../services/firewall.nix
    ../../services/sops.nix
    ../../services/ssh.nix
    ./direnv.nix

    # Monitoring
    # (import ../../services/agl-monitor/main.nix {
    #     inherit config pkgs lib;
    #     inherit agl-network-config;
    #   })

    # Network Services
    (import ./wake-on-lan.nix {inherit network-interface;})
    
    ## OpenVPN
    (import ../../services/openvpn.nix {inherit pkgs config lib;})
    (import ../../services/openvpn-host.nix {
      inherit pkgs config lib;
      inherit openvpn-cert-path openvpn-config-path;
    })
    
    ./power-settings.nix

    (import ../../services/garbage-collector.nix {inherit config pkgs;})

    # base config
    ( import ./secrets.nix {
      inherit openvpn-cert-path hostname;
    } )

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
