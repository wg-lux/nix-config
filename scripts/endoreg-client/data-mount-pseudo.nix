{ config, lib, pkgs, hostname, ... }:

let
    # Load and decode the JSON file
    hddConfig = builtins.fromJSON (builtins.readFile ../../config/hdd.json);

    # Access the specific client's hdd configuration
    clientHddConfig = hddConfig.${hostname}.hdd;

    # Assign variables directly from the JSON structure
    mapper_name = clientHddConfig.mapper.Pseudo;
    mountpoint_parent = clientHddConfig."mountpoint-parent".${mapper_name};
    mountpoint = "${mountpoint_parent}/${mapper_name}";
    uuid = clientHddConfig.uuid.${mapper_name};

    access_group = "pseudo-access";
    key_file = config.sops.secrets."sensitive-hdd/key/${mapper_name}".path; # File containing the passphrase
     
    scriptPath = pkgs.writeShellScriptBin "mount${mapper_name}" ''
    # Decrypt the partition
    sudo cryptsetup open UUID=${uuid} ${mapper_name} --key-file ${key_file}

    # Check if decryption was successful
    if [ $? -eq 0 ]; then
        # Create a mount point if it doesn't exist
        mkdir -p ${mountpoint}

        # Mount the file system
        if mount /dev/mapper/${mapper_name} ${mountpoint}; then
            echo "Mounted ${mapper_name} at ${mountpoint}."  >> /var/log/mount${mapper_name}.log
        else
            echo "Failed to mount ${mapper_name}."  >> /var/log/mount${mapper_name}.log
        fi
    else
        echo "Failed to decrypt ${mapper_name}."  >> /var/log/mount${mapper_name}.log

    fi
    
    sudo chown -R root:${access_group} ${mountpoint}
    sudo chmod -R 770 ${mountpoint}
  '';

in
{


    systemd.services.mountPseudoService = {
        description = "Mount ${mapper_name} HDD Service";
        serviceConfig = {
            Type = "oneshot";
            ExecStart = "${scriptPath}/bin/mount${mapper_name}";
            User="root";
            Group="root";
        };
        path = [ pkgs.sudo pkgs.cryptsetup pkgs.utillinux pkgs.coreutils ];
    };

    environment.systemPackages = with pkgs; [
    scriptPath
  ];

    ################' DELETED .service sufffix @ unit
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          subject.isInGroup("${access_group}") &&
          action.lookup("unit") == "mount${mapper_name}Service.service" &&
          (action.lookup("verb") == "start" || action.lookup("verb") == "stop")) {
        return polkit.Result.YES;
      }
    });
  '';
}