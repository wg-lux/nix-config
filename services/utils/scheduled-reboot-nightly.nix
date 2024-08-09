{ config, pkgs, ... }:

{
  systemd.services.scheduled-reboot-nightly = {
    description = "Scheduled Reboot Service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/systemctl reboot";
    };
  };

  systemd.timers.scheduled-reboot-timer = {
    description = "Timer for Scheduled Reboot";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00"; # Runs at 3am every day
      Persistent = true; # Ensures the job runs even if the system was down at the scheduled time
    };
    unitConfig = {
      Unit = "scheduled-reboot-nightly.service"; # Links the timer to the scheduled-reboot service
    };
  };



}