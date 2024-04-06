{ config, lib, pkgs, hostname, ... }:

let
    hddConfig = builtins.fromJSON (builtins.readFile ../../config/hdd.json);
    clientHddConfig = hddConfig.${hostname}.hdd;
    mapper_name = clientHddConfig.mapper.Processed;
    mountpoint_parent = clientHddConfig."mountpoint-parent".${mapper_name};
    mountpoint = "${mountpoint_parent}/${mapper_name}";
    access_group = "pseudo-access";

    scriptPath = pkgs.writeShellScriptBin "umount${mapper_name}" ''
        umount ${mountpoint}
        cryptsetup close ${mapper_name}
    '';
in 
{
    systemd.services.umountProcessedService = {
        description = "Umount ${mapper_name} HDD Service";
        serviceConfig = {
            Type = "oneshot";
            ExecStart = "${scriptPath}/bin/umount${mapper_name}";
            User="root";
            Group="root";
        };
        path = [ pkgs.sudo pkgs.cryptsetup pkgs.utillinux pkgs.coreutils ];
    };

    environment.systemPackages = with pkgs; [
    scriptPath
  ];


  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          subject.isInGroup("${access_group}") &&
          action.lookup("unit") == "umount${mapper_name}Service.service" &&
          (action.lookup("verb") == "start" || action.lookup("verb") == "stop")) {
        return polkit.Result.YES;
      }
    });
  '';
}
