let

    ssh = 22;

    # 9240-9299 seem safe to use

    keycloak = {
        host = 9240; # was [8080];
        host-https = 9241; # was [8443];
    };

    
    nginx = {
        local = 9249;
    };

    endoreg-client-manager-redis-port = 9251; # was 6379
    endoreg-client-manager-port = 9252; # was 9100
    endoreg-client-manager = {
        django = 9251;
        redis = 9252;
    };

    monitor = {
        django = 9251; # was 9243
        redis = 9262; # was 6382
    };
    
    anonymizer = {
        django = 9271; # was 9123
        redis = 9272; # was 6383
    };


    agl-home-django = 9281; # was 9129
    agl-home-django-redis = 9282; # was 6379
    endoreg-home = { # was agl-home-django
        django = 9281; # was 9129
        redis = 9282;
    };

    nextcloud = {
        host = 9291; # was 9128
    }; 

    openvpn = {
        host-udp = 1194; # was [1194];
        host-tcp = 1194; # was [1194];
    };

    dnsmasq = {
        client-udp = 53; # was [53];
        client-tcp = 53; # was [53];
    };

in {
    ssh = ssh;
    keycloak = keycloak;
    nginx = nginx;
    endoreg-client-manager = endoreg-client-manager;
    monitor = monitor;
    anonymizer = anonymizer;
    endoreg-home = endoreg-home; # was agl-home-django
    nextcloud = nextcloud;
    openvpn = openvpn;
    dnsmasq = dnsmasq;

    ### Depreciated
    # agl-public-nas-port = 443;
    # synology-dsm-port = 5545;
    # synology-video-port = 9946;
    # synology-drive-port = 12313;
    # synology-chat-port = 22323;
    

}