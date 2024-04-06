{...} : 
{
    programs.bash = {
    enable = false;
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
    };
  };
}