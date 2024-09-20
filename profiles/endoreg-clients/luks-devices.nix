{config, custom-hardware-config, ...}:
let 
    hostname = config.networking.hostName;
    _hdd_config = builtins.fromJSON (builtins.readFile ../../config/hdd.json);
    hdd_config = _hdd_config.${hostname}.hdd;
    id_dropoff = hdd_config.uuid.DropOff;
    id_processed = hdd_config.uuid.Processed;
    id_pseudo = hdd_config.uuid.Pseudo;
    mapper_dropoff = hdd_config.mapper.DropOff;
    mapper_processed = hdd_config.mapper.Processed;
    mapper_pseudo = hdd_config.mapper.Pseudo;
    mountpoint_dropoff = "${hdd_config.mountpoint-parent.DropOff}/${mapper_dropoff}";
    mountpoint_processed = "${hdd_config.mountpoint-parent.Processed}/${mapper_processed}";
    mountpoint_pseudo = "${hdd_config.mountpoint-parent.Pseudo}/${mapper_pseudo}";

    file-system-base-uuid = custom-hardware-config.file-system-base-uuid;
    file-system-boot-uuid = custom-hardware-config.file-system-boot-uuid;
    swap-device-uuid = custom-hardware-config.swap-device-uuid;

    luks-hdd-intern-uuid = custom-hardware-config.luks-hdd-intern-uuid;
    luks-swap-uuid = custom-hardware-config.luks-swap-uuid;
in
{
    fileSystems."/" =
    { 
      device = "/dev/disk/by-uuid/${file-system-base-uuid}";
      fsType = "ext4";
    };
  
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/${file-system-boot-uuid}";
      fsType = "vfat";
    };

  swapDevices =
    [ 
      { 
        device = "/dev/disk/by-uuid/${swap-device-uuid}"; 
      }
    ];

  boot.initrd.luks.devices = {
    # Root
    "luks-${luks-hdd-intern-uuid}" = {
        device = "/dev/disk/by-uuid/${luks-hdd-intern-uuid}";
    };
    # Swap
    "luks-${luks-swap-uuid}" = { 
        device = "/dev/disk/by-uuid/${luks-swap-uuid}";
    };
  };
}
