{ 
    pkgs,
    agl-network-config,
    ...
}: 
let

    openvpnServiceName = "openvpn-aglNet.service";
    # agl-network-config.services.nfs-share.local-path = "/home/agl-admin/nfs-share";


    agl-c-script-path = pkgs.writeShellScriptBin "agl-c" ''
        ${pkgs.systemd}/bin/systemctl start ${openvpnServiceName}
        sleep 1
        ${pkgs.mount}/bin/mount ${agl-network-config.services.nfs-share.local-path}

    '';

    agl-dc-script-path = pkgs.writeShellScriptBin "agl-dc" ''
        ${pkgs.umount}/bin/umount ${agl-network-config.services.nfs-share.local-path}
        sleep 1
        ${pkgs.systemd}/bin/systemctl stop ${openvpnServiceName}

    '';

    reboot-script-path = pkgs.writeShellScriptBin "rstrt" ''
        ${agl-dc-script-path}/bin/agl-dc

        reboot
    '';

in
{
    environment.systemPackages = [ 
        agl-c-script-path
        agl-dc-script-path
        reboot-script-path
    ];

    services.rpcbind.enable = true;

    # Mount NFS Shares
    fileSystems."${agl-network-config.services.nfs-share.local-path}" = {
        device = "${agl-network-config.services.nfs-share.ip}:${agl-network-config.services.nfs-share.mount-path}";
        fsType = "nfs";
        options = [
            # https://linux.die.net/man/5/nfs
            # "clientaddr=x.x.x.x"  # Client IP address
            "vers=4.1"
            "async"  # Asynchronous writes
            "bg"
            "rw"  # Read and write permissions
            "hard"  # Hard mount
            "intr"  # Allow interrupts
            "rsize=8192"  # Read size (adjust as needed)
            "wsize=8192"  # Write size (adjust as needed)
            "noatime"  # Don't update access time to improve performance
            "lock"
            "_netdev"  # This is a network device
            "noauto"
            "x-systemd.idle-timeout=600"
        ];
    };

}