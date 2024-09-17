{pkgs, config, lib, ...}: {
  environment.systemPackages = with pkgs; [
    # obsidian
    # qFlipper
    opensc
    pcsclite
    gnupg
    tesseract
    # zenity #
    gnome.zenity
    spotify
    nodejs_18

    # Database
    dbeaver-bin
    beekeeper-studio

    # Utility
    synology-drive-client
    libreoffice-fresh
    sticky
    nextcloud-client

    # Video Recording

    obs-studio
    # obs-studio-plugins.obs-nvfbc
    # obs-studio-plugins.input-overlay
    # obs-studio-plugins.obs-backgroundremoval
    # obs-studio-plugins.advanced-scene-switcher
    # obs-studio-plugins.obs-pipewire-audio-capture

    # Audio Processing
    # alsa-firmware
    # alsa-oss
    # alsa-lib
    # alsa-tools
    # alsa-plugins
    # apulse
    # audacity
    # ardour
    # strawberry
    # kdenlive
    # rnnoise-plugin
    # mixxx

    # Image Processing
    # gimp
    # inkscape

    # Video Processing

    # CAD / Cutting / printing
    # openscad
    # appimage-run

    # System states
    ( import ../../scripts/endoreg-client/system-idle.nix {inherit pkgs;})


    # Steam
    # steam-run
    # steam-tui
    # protonup-qt
    # protonup-ng

    thunderbird

  ];

  programs.htop.enable = true; # Enable htop monitoring
  
  # enable thunderbird
  # programs.thunderbird.enable = true;

  

  # Steam
  # https://nixos.wiki/wiki/Steam
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #   localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  #   extraCompatPackages = [
  #     pkgs.proton-ge-bin
  #   ];
  # };

  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #     "steam"
  #     "steam-original"
  #     "steam-run"
  #   ];




}