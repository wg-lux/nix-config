{ config, lib, pkgs, ... }:

let
    mountpoint_parent_file = "/root/.secrets/hdd-mount-point-parent-processed";
    mapper_name_file = "/root/.secrets/hdd-mapper-name-processed"; # File containing the name of the mapper
    key_file = "/root/.secrets/hdd-key-processed"; # File containing the passphrase
    uuid_file = "/root/.secrets/hdd-uuid-processed"; # UUID of the encrypted partition

  scriptPath = pkgs.writeShellScriptBin "mountProcessed" ''
    UUID=$(cat ${uuid_file})
    PASSPHRASE=$(cat ${key_file})
    MOUNTPOINT_PARENT=$(cat ${mountpoint_parent_file})
    MAPPER_NAME=$(cat ${mapper_name_file})
    MOUNTPOINT=$MOUNTPOINT_PARENT/$MAPPER_NAME

    # Decrypt the partition
    cryptsetup open UUID=$UUID $MAPPER_NAME --key-file ${key_file}

    # Check if decryption was successful
    if [ $? -eq 0 ]; then
        # Create a mount point if it doesn't exist
        mkdir -p $MOUNTPOINT

        # Mount the file system
        if mount /dev/mapper/$MAPPER_NAME $MOUNTPOINT; then
            echo "$MAPPER_NAME mounted successfully" >> /var/log/mountProcessed.log
        else
            echo "Failed to mount $MAPPER_NAME." >> /var/log/mountProcessed.log
        fi
    else
        echo "Failed to decrypt $MAPPER_NAME." >> /var/log/mountProcessed.log
    fi

    chown -R root:pseudo-access $MOUNTPOINT
    chmod -R 770 $MOUNTPOINT

  '';
in
{
  systemd.services.mountProcessedService = {
    description = "Mount Processed HDD Service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${scriptPath}/bin/mountProcessed"; # ${pkgs.sudo}/bin/sudo 
      RemainAfterExit = false;
      User = "root";
      Group = "root";
    };
    path = [ pkgs.sudo pkgs.cryptsetup pkgs.utillinux pkgs.coreutils ];

  };

  environment.systemPackages = with pkgs; [
    scriptPath
  ];


  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          subject.isInGroup("pseudo-access") &&
          action.lookup("unit") == "mountProcessedService.service" &&
          (action.lookup("verb") == "start" || action.lookup("verb") == "stop")) {
        return polkit.Result.YES;
      }
    });
  '';

}
