{config, ...}:
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
in
{

  ##
  ##
    boot = {
        initrd.secrets = {
          "/keyfile" = "/boot/encryption_keyfile";
        };
    };


    fileSystems."/" ={
      device = "/dev/disk/by-uuid/c8fdc2af-c01c-4237-9f58-91f7ad7acf50";
      fsType = "ext4";
    };
  
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9675-A87D";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d321d297-a334-4a1a-a77b-00b2974f4358"; }
  ];

  boot.initrd.luks.devices = {
    # Root
    "luks-274d2191-1443-41f9-bee5-0efc0fc705bf" = {
        device = "/dev/disk/by-uuid/274d2191-1443-41f9-bee5-0efc0fc705bf";
        keyFile = "/keyfile";
        fallbackToPassword = true;
    };
    # Swap
    "luks-6e991f24-1dbb-4bd8-a91c-849b887a0f6e" = { 
        device = "/dev/disk/by-uuid/6e991f24-1dbb-4bd8-a91c-849b887a0f6e";
        keyFile = "/keyfile";
        fallbackToPassword = true;
    };
  };
}
