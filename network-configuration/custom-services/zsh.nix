{

    enable = true;
    autosuggestions.enable = true;
    # zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
        eval "$(direnv hook zsh)"
    '';
    ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
        "git"
        "npm"
        "history"
        "node"
        "rust"
        "deno"
        ];
    };
    shellAliases = {
        l = "ls -alh";
        ll = "ls -l";
        ls = "ls --color=tty";
        py = "python -m ";
        pshell = "nix-shell -p poetry";
        un = "update-nix";
        cleanup = "nix-collect-garbage -d";
        cleanup-roots = "sudo rm /nix/var/nix/gcroots/auto/*";
        optimize = "nix-store --optimize";
        confdir = "cd ~/nix-config/config";
        mkmigrations-erh = "python endoreg_home/manage.py makemigrations";
        migrate-erh = "python endoreg_home/manage.py migrate";
        run-erh = "python endoreg_home/manage.py runserver";      
        journalctl-clear = "sudo journalctl --flush --rotate --vacuum-time=1s";
        
        m-pseudo = "sudo mountPseudo";
        m-proc = "sudo mountProcessed";
        m-do = "sudo mountDropOff";
        um-pseudo = "sudo umountPseudo";
        um-proc = "sudo umountProcessed";
        um-do = "sudo umountDropOff";

        vpn-start = "systemctl start openvpn-aglNet";
        vpn-stop = "systemctl stop openvpn-aglNet";
        vpn-restart = "systemctl restart openvpn-aglNet";
        vpn-status = "systemctl status openvpn-aglNet";
        
        vpn-log = "cat /etc/custom-logs/openvpn-aglNet-log.csv";
        vpn-log-errors = "cat /etc/custom-logs/openvpn-aglNet-error.log";
        vpn-log-run = "log-openvpn";
    };

}