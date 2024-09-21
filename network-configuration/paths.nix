{
    # Paths
    agl-home-django-path = "/home/agl-admin/agl-home-django";
    agl-monitor-path = "/home/agl-admin/agl-monitor";
    nfs-share-all-local-path = "/home/agl-admin/nfs-share";
    nfs-share-all-mount-path = "/volume1/agl-share";
    # openvpnConfigPath = "/home/agl-admin/.openvpn";
    # openvpnCertPath = "/home/agl-admin/openvpn-cert";
    openvpn-config-path = "/etc/openvpn";
    openvpn-client-config-file = "aglNet.conf";
    openvpn-host-config-file = "aglNetHost.conf";

    openvpn-cert-path = "/etc/openvpn-cert";

    ssh-id-ed25519-file-path = "/etc/agl-admin-identity/id_ed25519";
    age-key-file-path = "/etc/agl-admin-identity/age-keys.txt";

    # This path is used in home-manager to copy the age key file to the user's home directory
    # the path is relative to the user's home directory even though it starts with a slash
    # ssh-id-ed25519-user-file-path = "/.ssh/id_ed25519";
    # age-key-user-file-path = "/.config/age/keys.txt" ;

    # endoRegClientManagerPath = "/home/agl-admin/endoreg-client-manager"; #TODO DELETE
    endoreg-client-manager-path = "/home/agl-admin/endoreg-client-manager";
    endoreg-client-manager-dropoff-dir = "/mnt/hdd-sensitive/DropOff";
    endoreg-client-manager-pseudo-dir = "/mnt/hdd-sensitive/Pseudo";
    endoreg-client-manager-processed-dir = "/mnt/hdd-sensitive/Processed";

    agl-anonymizer-dir = "/home/agl-admin/agl_anonymizer/agl_anonymizer";
}