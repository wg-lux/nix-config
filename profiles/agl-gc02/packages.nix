{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # obsidian
    qFlipper
    opensc
    pcsclite
    gnupg
    tesseract
    zenity

    # System states
    ( import ../../scripts/endoreg-client/system-idle.nix {inherit pkgs;})

  ];
}