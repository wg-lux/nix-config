let 
    domains = import ./domains.nix;
    ips = import ./ips.nix;
    ports = import ./ports.nix;
    paths = import ./paths.nix;
    service-configs = import ./service-configs.nix;
    hardware = import ./hardware.nix;
in
{

    domains = domains;
    ips = ips;
    ports = ports;
    paths = paths;
    service-configs = service-configs;
    hardware = hardware;

    #TODO Resolve this duplication?
    domain = domains.main-domain;

    # hostnames = {};

    services = {
        main_nginx = {
            ip = ips.main-nginx;
            # port = ports.local-nginx-port; # Default ports
        };
        local_nginx = {
            port = ports.local-nginx-port;
        };
        synology-drive = {
            ip = ips.synology-service;
            port = ports.synology-drive-port;
        };
        synology-chat = {
            ip = ips.synology-service;
            port = ports.synology-chat-port;
        };
        synology-video = {
            ip = ips.synology-service;
            port = ports.synology-video-port;
        };
        synology-dsm = {
            ip = ips.synology-service;
            port = ports.synology-dsm-port;
        };

        nextcloud = {
            ip = ips.nextcloud;
            user = service-configs.nextcloud-user;
            group = service-configs.nextcloud-group;
            domain = domains.nextcloud-public-domain;
            port = ports.nextcloud-port;
        };

        # Synology public nas (quickconnect: agl-public-nas.quickconnect.to)
        agl-public-nas = {
            ip = ips.agl-nas-01;
            port = ports.agl-public-nas-port;
        };

        ldap = {
            ip = ips.agl-nas-02;
            domain = domains.ldap-domain;
            port = ports.ldap-port;
        };

        # different structure
        local-monitoring-config = {
			grafana-port = ports.local-monitoring-grafana-port;
			prometheus-port = ports.local-monitoring-prometheus-port;
			prometheus-node-exporter-port = ports.local-monitoring-prometheus-node-exporter-port;
			loki-port = ports.local-monitoring-loki-port;
			promtail-port = ports.local-monitoring-promtail-port;
		};

        # EndoReg Home
        agl-home-django = {
            ip = ips.agl-server-04;
            port = ports.agl-home-django-port;
            path = paths.agl-home-django-path;
        };

        agl-monitor = {
            ip = ips.agl-server-04;
            port = ports.agl-monitor-port;
            path = paths.agl-monitor-path;
            user = service-configs.agl-monitor-user;
            group = service-configs.agl-monitor-group;
            redis-port = ports.agl-monitor-redis-port;
            redis-bind = service-configs.agl-monitor-redis-bind;
            django-debug = service-configs.agl-monitor-django-debug;
            django-settings-module = service-configs.agl-monitor-django-settings-module;			
        };

        # G-Play
        agl-g-play = {

        };
    
        # EndoReg Local
        endoreg-client-manager = {
            port = ports.endoreg-client-manager-port;
        };

        # Grafana
        grafana = {
            ip = ips.agl-server-04;
            port = ports.main-grafana-port;
            url = domains.grafana-url;
        };

        # Keycloak Server
        keycloak = {
            ip = ips.agl-server-03;
            port = ports.keycloak-port;
        };

        # NFS FILE SHARE
        nfs-share = {
            ip = ips.agl-nas-02; #
            local-path = paths.nfs-share-all-local-path;
            mount-path = paths.nfs-share-all-mount-path;
        };

    };

    endoreg-client-manager-config = {
        path = paths.endoreg-client-manager-path;
        dropoff-dir = paths.endoreg-client-manager-dropoff-dir;
        pseudo-dir = paths.endoreg-client-manager-pseudo-dir;
        processed-dir = paths.endoreg-client-manager-processed-dir;
        django-debug = service-configs.endoreg-client-manager-django-debug;
        django-settings-module = service-configs.endoreg-client-manager-django-settings-module;
        user = service-configs.base-service-user;
        group = service-configs.endoreg-client-pseudo-access-group;
        redis-port = ports.endoreg-client-manager-redis-port;
        port = ports.endoreg-client-manager-port;
        agl-anonymizer-port = ports.agl-anonymizer-port;
        agl-anonymizer-dir = paths.agl-anonymizer-dir;
        agl-anonymizer-django-settings-module = service-configs.agl-anonymizer-django-settings-module;
    };

    agl-home-django-config = {
		path = paths.agl-network-config.services.agl-home-django.path;
		user = service-configs.base-service-user;
		group = service-configs.endoreg-client-pseudo-access-group;
		redis-port = ports.agl-home-django-redis-port;
		ip = ips.agl-network-config.services.agl-home-django.ip;
		port = ports.agl-network-config.services.agl-home-django.port;
		django-debug = service-configs.agl-home-django-django-debug;
		django-settings-module = service-configs.agl-home-django-django-settings-module;
	};

}