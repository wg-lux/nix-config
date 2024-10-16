let
    base-service-user = "agl-admin";
    service-user = "service-user";
    agl-admin-user = "agl-admin";
    maintenance-user = "maintenance-user";
    center-user = "center-user";
    logging-user = "logging-user";

    service-group = "service-user";

    endoreg-client-pseudo-access-group = "pseudo-access"; #

    agl-monitor-settings-mode = "prod"; # one of "dev" or "prod"
in
{
    # Users
    base-service-user = base-service-user;
    service-user = service-user;
    admin-user = agl-admin-user;
    maintenance-user = maintenance-user;
    center-user = center-user;
    logging-user = logging-user;

    # Groups
    service-group = service-group;
    agl-admin-user = agl-admin-user;
    endoreg-client-pseudo-access-group = endoreg-client-pseudo-access-group;

    agl-monitor-group = service-group;
    nextcloud-group = "aglnet-public-service";
    openvpn-cert-group = "openvpn";

    # Users Extra Groups
    admin-user-extra-groups = [ 
        "networkmanager" 
        "wheel" 
        "video" 
        "sound"
        "audio"
        "pulse-access"
    ];

    service-user-extra-groups = [ 
        "networkmanager"
        "wheel"
        service-group
    ];

    base-user-extra-groups = [ 
        "audio" 
        "sound"
    ];

    # Custom Services
    agl-monitor-user = logging-user;

    # Anonymizer

    agl-anonymizer-settings-module = "agl_anonymizer.settings";

    # Sops
    sops-default-format = "yaml";
    sops-user = agl-admin-user;

    # Nextcloud
    nextcloud-user = "nextcloud";
    nextcloud-db-name = "nextcloud";
    nextcloud-db-type = "mysql";

    # OpenVPN
    openvpn-cert-owner = "openvpn";
    openvpn-network-interface = "tun0";
    openvpn-host-hostname = "agl-server-01";
    openvpn-cert-mode = "0600";
    openvpn-service-name = "openvpn-aglNet";

    # CustomScript Names

    openvpn-custom-log-timer-on-calendar = "*:0/15"; # Every 15 minutes
    openvpn-custom-log-script-name = "log-openvpn";
    clear-custom-logs-script-name = "clear-custom-logs";

    # SSH
    ssh-user = agl-admin-user;
    ssh-secret-file-mode = "0600";
    
    # Binds
    agl-monitor-redis-bind = "127.0.0.1";

    # Misc
    agl-monitor-django-debug = false; # breaks if true?!  https://discourse.nixos.org/t/packaged-python-application-cannot-be-executed/42656
    endoreg-client-manager-django-debug = true;
    agl-home-django-django-debug = false;


    agl-home-django-settings-module = "endoreg_home.settings_prod";
    agl-monitor-django-settings-module = "agl_monitor.settings_${agl-monitor-settings-mode}";
    agl-anonymizer-django-settings-module = "agl_anonymizer.settings";
    endoreg-client-manager-django-settings-module = "endoreg_client_manager.settings";

}