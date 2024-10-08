let

    local-nginx-port = 443;

in {
    ssh-port = 22;
    agl-public-nas-port = 443;
    ldap-port = 389;

    main-grafana-port = 2342;

    local-monitoring-grafana-port = 3010;
    local-monitoring-prometheus-port = 9090;
    local-monitoring-prometheus-node-exporter-port = 3021;
    local-monitoring-loki-port = 3030;
    local-monitoring-promtail-port = 3031;

    synology-dsm-port = 5545;
    endoreg-client-manager-redis-port = 6379;
    agl-monitor-redis-port = 6382;
    agl-home-django-redis-port = 6379;
    local-nginx-port = local-nginx-port;
    nextcloud-port = local-nginx-port;
    keycloak-port = 8080;

    endoreg-client-manager-port = 9100;
    agl-anonymizer-port = 9123;
    nextcloud-local-port = 9128;
    agl-home-django-port = 9129;
    agl-monitor-port = 9243;
    agl-monitor-host-port = 9243;
    synology-video-port = 9946;
    synology-drive-port = 12313;
    synology-chat-port = 22323;

    # OpenVPN
    openvpn-client-tcp-ports = [53]; #TODO Actually DNSMASQ Ports; DEPRECEATED
    openvpn-client-udp-ports = [53]; 
    dnsmasq-client-tcp-ports = [53]; #TODO Use
    dnsmasq-client-udp-ports = [53]; 
    openvpn-host-tcp-ports = [1194];
    openvpn-host-udp-ports = [1194];

    # main-nginx-port = 443; #TODO test if change from default to strict definition breaks anything

    

}