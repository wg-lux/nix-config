{pkgs}:

pkgs.writeShellScriptBin "system-idle" ''
    sudo umountDropOff
    sudo umountPseudo
    sudo umountProcessed

    # Enable SSH connections, assuming firewall control
    sudo systemctl restart sshd.service
    ''