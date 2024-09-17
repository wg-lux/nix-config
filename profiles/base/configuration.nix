{ 
  config, pkgs, lib, inputs, 
  network_interface, 
  openvpnCertPath,
  openvpnConfigPath ? "home/agl-admin/.openvpn",
  base-profile-settings,
  hostname,
  ... 
}: 

{
  # asd 
  imports = [
    ./etc.nix
    (import ./system-packages.nix {inherit config pkgs;})
    (import ./users.nix { inherit hostname config pkgs inputs openvpnCertPath; })
    (import ./xserver.nix {inherit pkgs; } )
    ./vscode.nix
    ./zsh.nix
    # base services
    ../../services/firewall.nix
    ../../services/sops.nix
    ../../services/ssh.nix
    ./direnv.nix
    (import ./wake-on-lan.nix {inherit network_interface;})
    (import ../../services/openvpn.nix {inherit pkgs config lib;})
    ( import ../../services/openvpn-host.nix {inherit pkgs config lib openvpnConfigPath;})
    ./power-settings.nix
    (import ../../services/garbage-collector.nix {inherit config pkgs;})

    # base config
    ( import ./secrets.nix {
      inherit openvpnCertPath hostname;
    } )
    ./locale-settings.nix
    ./printer.nix
    ./audio.nix
    ../../scripts/util-scripts.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

  };
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_6_9; 
  boot.kernelPackages = pkgs.linuxPackages_6_10;

  programs.git = {
      enable = true;
  };

}
