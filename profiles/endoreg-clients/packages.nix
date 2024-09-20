{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    opensc
    pcsclite
    gnupg
    tesseract
    gnome.zenity
    spotify
    nodejs_18
    nextcloud-client
    appimage-run
    libreoffice-fresh

    # Database
    dbeaver-bin
  
    # System states
    ( import ../../scripts/endoreg-client/system-idle.nix {inherit pkgs;})

  ];
}