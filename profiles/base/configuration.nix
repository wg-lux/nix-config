{ 
  config, pkgs, lib, inputs, 
  network_interface, 
  openvpnCertPath,
  openvpnConfigPath ? "home/agl-admin/.openvpn", 
  hostname,
  ... }: 

{

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
    ./locale-settings.nix
    ./printer.nix
    ./audio.nix
    ../../scripts/util-scripts.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.git = {
      enable = true; # IF GIT SHOULD BREAK SOME IN THE PUSHES OR NEW BUILDS AFTER 24-01-18 its probably this
      config = {
      user.name = "maddonix";
      user.email = "tlux14@googlemail.com"; 
    };
  };

}
