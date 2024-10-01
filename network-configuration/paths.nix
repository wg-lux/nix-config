let
    custom-logs-dir = "/etc/custom-logs"; # Relative to /etc
    logging-user-dir = "etc/logging-user";

in
{
    # Paths

    # Users
    logging-user-dir = logging-user-dir;

    agl-home-django-path = "/home/agl-admin/agl-home-django";
    # agl-monitor-path = "/home/agl-admin/agl-monitor";
    # agl-monitor-config-json-file = "/etc/agl-monitor.json";
    
    
    agl-monitor-celery-signal-logfile = "${custom-logs-dir}/agl-monitor-celery-signal.log";
    agl-monitor-service-dir = "${logging-user-dir}/agl-monitor";
    # agl-monitor-django-secret-file = "/etc/agl-monitor-secret";

    nfs-share-all-local-path = "/home/agl-admin/nfs-share";
    nfs-share-all-mount-path = "/volume1/agl-share";
    # openvpnConfigPath = "/home/agl-admin/.openvpn";
    # openvpnCertPath = "/home/agl-admin/openvpn-cert";
    openvpn-config-path = "/etc/openvpn";
    openvpn-client-config-file = "aglNet.conf";
    openvpn-host-config-file = "aglNetHost.conf";

    custom-logs-dir = custom-logs-dir;
    openvpn-custom-log-path = "/etc/custom-logs/openvpn-aglNet-log.csv";
    openvpn-custom-error-log-path = "/etc/custom-logs/openvpn-aglNet-error.log";

    openvpn-cert-path = "/etc/openvpn-cert";

    ssh-id-ed25519-file-path = "/etc/agl-admin-identity/id_ed25519";
    # ssh-id-ed25519-file-path = "/home/agl-admin/id_ed25519";
    age-key-file-path = "/etc/agl-admin-identity/age-keys.txt";
    age-key-file-user-path = "/home/agl-admin/.config/sops/age/keys.txt";

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