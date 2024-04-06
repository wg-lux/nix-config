{ config, pkgs, ... }:

{
# check status with: systemctl list-timers | grep my-nix-gc
# check logs with: journalctl -u my-nix-gc

  systemd.services.my-nix-gc = {
    description = "Weekly Nix Garbage Collection";
    serviceConfig.Type = "oneshot";
    script = "${pkgs.nix}/bin/nix-collect-garbage -d";
  };

  systemd.timers.my-nix-gc = {
    description = "Weekly Nix Garbage Collection Timer";
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "weekly";
    timerConfig.Persistent = true;
  };
}
