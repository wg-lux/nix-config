{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # obsidian
    qFlipper
    opensc
    pcsclite
    gnupg
    tesseract
    zenity

    # ( import  ../../scripts/endoreg-client/data-mount.nix { inherit pkgs ; })
    # ( import  ../../scripts/endoreg-client/data-umount.nix { inherit pkgs ; })
    # ( import ../../scripts/endoreg-client/data-retrieve.nix { inherit pkgs ; })
    
  
    # System states
    ( import ../../scripts/endoreg-client/system-idle.nix {inherit pkgs;})

  ];
}