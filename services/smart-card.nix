{pkgs, ...}: {
    services.pcscd.enable = true;

    environment.systemPackages = with pkgs; [
        opensc
        pcsclite
        pcsctools
        gnupg
    ];
}