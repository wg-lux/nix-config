{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # obsidian
    # qFlipper
    opensc
    pcsclite
    gnupg
    tesseract
    gnome.zenity
    spotify
    steam

    # Database
    dbeaver-bin
    beekeeper-studio

    # Utility
    synology-drive-client
    libreoffice-fresh
    sticky

    # Video Recording

    obs-studio
    # obs-studio-plugins.obs-nvfbc
    # obs-studio-plugins.input-overlay
    # obs-studio-plugins.obs-backgroundremoval
    # obs-studio-plugins.advanced-scene-switcher
    # obs-studio-plugins.obs-pipewire-audio-capture

    # Audio Processing
    ardour
    strawberry
    kdenlive
    # mixxx

    # Image Processing
    gimp
    inkscape

    # Video Processing

    # CAD / Cutting / printing
    openscad
    appimage-run

    # System states
    ( import ../../scripts/endoreg-client/system-idle.nix {inherit pkgs;})

  ];

  programs.htop.enable = true; # Enable htop monitoring

}