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
    boot = {
        initrd.secrets = {
          "/keyfile" = "/boot/encryption_keyfile";
        };
    };


    fileSystems."/" =
    { device = "/dev/disk/by-uuid/57583232-d300-40d8-ae04-3ae510697a13";
      fsType = "ext4";
    };
  
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/739A-7657";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/8c497dfb-c2ae-46d1-9314-305dddd50620"; }
    ];

  boot.initrd.luks.devices = {
    # Root
    "luks-2d8b5a20-2780-43b6-a0f8-e26bd36d19e6" = {
        device = "/dev/disk/by-uuid/2d8b5a20-2780-43b6-a0f8-e26bd36d19e6";
        keyFile = "/keyfile";
        fallbackToPassword = true;
    };
    # Swap
    "luks-4da269f8-08c4-4f1d-9fb3-dfd440c4bd32" = { 
        device = "/dev/disk/by-uuid/4da269f8-08c4-4f1d-9fb3-dfd440c4bd32";
        keyFile = "/keyfile";
        fallbackToPassword = true;
    };
    # Optional Devices
    # "${mapper_dropoff}" = {
    #     device = "/dev/disk/by-uuid/${id_dropoff}";
    #     keyFile = "/keyfile";
    # };
    # "${mapper_pseudo}" = {
    #     device = "/dev/disk/by-uuid/${id_pseudo}";
    #     keyFile = "/keyfile";
    # };
    # "${mapper_processed}" = {
    #     device = "/dev/disk/by-uuid/${id_processed}";
    #     keyFile = "/keyfile";
    # };
  };

    # Taken from hardware-configuration.nix
    # fileSystems."${mountpoint_dropoff}" = {
    #     device = "/dev/disk/by-uuid/${id_dropoff}";
    #     fsType = "ext4";
    #     options = ["nofail" "noatime" "x-systemd.device-timeout=1"];
    # };

    # fileSystems."${mountpoint_pseudo}" = {
    #     device = "/dev/disk/by-uuid/${id_pseudo}";
    #     fsType = "ext4";
    #     options = ["nofail" "noatime" "x-systemd.device-timeout=1"];
    # };

    # fileSystems."${mountpoint_processed}" = {
    #     device = "/dev/disk/by-uuid/${id_processed}";
    #     fsType = "ext4";
    #     options = [ "nofail" "noatime" "x-systemd.device-timeout=1"];
    # };



}
