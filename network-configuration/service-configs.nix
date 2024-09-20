let
    base-service-user = "agl-admin";
in
{
    # Users
    base-service-user = base-service-user;
    endoreg-client-pseudo-access-group = "pseudo-access";
    agl-monitor-user = base-service-user;

    nextcloud-user = "nextcloud";
    nextcloud-db-name = "nextcloud";
    nextcloud-db-type = "mysql";

    # OpenVPN
    openvpn-network-interface = "tun0";

    # Groups
    agl-monitor-group = "pseudo-access";
    nextcloud-group = "aglnet-public-service";
    
    # Binds
    agl-monitor-redis-bind = "127.0.0.1";

    # Misc
    agl-monitor-django-debug = false;
    endoreg-client-manager-django-debug = true;
    agl-home-django-django-debug = false;


    agl-home-django-django-settings-module = "endoreg_home.settings_prod";
    agl-monitor-django-settings-module = "agl_monitor.settings";
    agl-anonymizer-django-settings-module = "agl_anonymizer.settings";
    endoreg-client-manager-django-settings-module = "endoreg_client_manager.settings";
}