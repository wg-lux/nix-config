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

    users = {
        base-service-user = service-configs.base-service-user;
        service-user = service-configs.service-user;
        admin-user = service-configs.agl-admin-user;
        maintenance-user = service-configs.maintenance-user;
        center-user = service-configs.center-user;
        logging-user = service-configs.logging-user;
    };

    custom-logs = {
        owner = service-configs.service-user;
        group = service-configs.service-group;
        dir = paths.custom-logs-dir;

        clear-logs-script-name = service-configs.clear-custom-logs-script-name;

        openvpn-custom-log-script-name = service-configs.openvpn-custom-log-script-name;
        openvpn-log = paths.openvpn-custom-log-path;
        openvpn-error-log = paths.openvpn-custom-error-log-path;
        openvpn-custom-log-timer-on-calendar = service-configs.openvpn-custom-log-timer-on-calendar;

        ping-vpn-ip = ips.openvpn-host-ip;
        ping-www-ip = "8.8.8.8";
    };

    #TODO Resolve this duplication?
    domain = domains.main-domain;

    hostnames = import ./hostnames.nix;

    identity-file-paths = {
        age-key-file = paths.age-key-file-path;
        age-key-file-user = paths.age-key-user-file-path;
        ssh-id-ed25519-file = paths.ssh-id-ed25519-file-path;
        ssh-id-ed25519-user-file = paths.ssh-id-ed25519-user-file-path;
    };

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

        dnsmasq = {
            tcp = ports.dnsmasq-client-tcp-ports;
            udp = ports.dnsmasq-client-udp-ports;
        };

        openvpn = {
            domain = domains.main-domain;
            service-name = service-configs.openvpn-service-name;

            network-interface = service-configs.openvpn-network-interface;
            host-hostname = service-configs.openvpn-host-hostname;
            intern-subdomain-suffix = domains.intern-subdomain-suffix;

            host-tcp-ports = ports.openvpn-host-tcp-ports;
            host-udp-ports = ports.openvpn-host-udp-ports;
            client-tcp-ports = ports.openvpn-client-tcp-ports;
            client-udp-ports = ports.openvpn-client-udp-ports;

            host-ip = ips.openvpn-host-ip;
            host-local-ip = ips.openvpn-host-local-ip;

            custom-log-path = paths.openvpn-custom-log-path;
            cert-path = paths.openvpn-cert-path;
            config-path = paths.openvpn-config-path;

            client-config-file = paths.openvpn-client-config-file;
            host-config-file = paths.openvpn-host-config-file;

            user = service-configs.openvpn-cert-owner;
            group = service-configs.openvpn-cert-group;
            file-mode = service-configs.openvpn-cert-mode;
        };

        nextcloud = {
            ip = ips.nextcloud;
            user = service-configs.nextcloud-user;
            group = service-configs.nextcloud-group;
            domain = domains.nextcloud-public-domain;
            port = ports.nextcloud-port;
        };

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
            ip = ips.agl-home-django;
            port = ports.agl-home-django-port;
            path = paths.agl-home-django-path;

            user = service-configs.base-service-user; #TODO
            group = service-configs.endoreg-client-pseudo-access-group; #TODO
            redis-port = ports.agl-home-django-redis-port;

            django-debug = service-configs.agl-home-django-django-debug;
            django-settings-module = service-configs.agl-home-django-django-settings-module;
	
        };

        agl-monitor = {
            host-ip = ips.agl-monitor-host;
            host-port = ports.agl-monitor-host-port;
            bind = ips.localhost;
            user-dir = paths.agl-monitor-user-dir;
            monitor-dir = paths.agl-monitor-service-dir;
            config-json-file = paths.agl-monitor-config-json-file;
            custom-logs-dir = paths.custom-logs-dir;
            django-debug = service-configs.agl-monitor-django-debug;
            django-secret-key = "change-me"; # TODO
            django-settings-module = service-configs.agl-monitor-django-settings-module;
            enable = true;
            group = service-configs.agl-monitor-group;
            port = ports.agl-monitor-port;
            redis-bind = ips.localhost_ip;
            redis-port = ports.agl-monitor-redis-port;
            user = service-configs.agl-monitor-user;
            conf = {
                CACHES = {
                    "default" = {
                        BACKEND = "django_redis.cache.RedisCache";
                        LOCATION = "redis://localhost:${ports.agl-monitor-redis-port}/0";
                        TIMEOUT = "300";
                        OPTIONS = {
                            "CLIENT_CLASS" = "django_redis.client.DefaultClient";
                        };
                    };
                };
                CELERY_BROKER_URL = "redis://localhost:${ports.agl-monitor-redis-port}/0";
                CELERY_RESULT_BACKEND = "redis://localhost:${ports.agl-monitor-redis-port}/0";
                CELERY_ACCEPT_CONTENT = "application/json";
                CELERY_TASK_SERIALIZER = "json";
                CELERY_RESULT_SERIALIZER = "json";
                CELERY_TIMEZONE = "UTC";
                CELERY_BEAT_SCHEDULER = "django_celery_beat.schedulers:DatabaseScheduler";

                CELERY_SIGNAL_LOGFILE = paths.agl-monitor-celery-signal-logfile;
            };
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

        ssh = {
            port = ports.ssh-port;
            id-ed25519-file-path = paths.ssh-id-ed25519-file-path;
            user = service-configs.admin-user;
            secret-file-mode = service-configs.ssh-secret-file-mode;
        };

        sops = {
            # default-sops-file = ../secrets/secrets.yaml;
            default-format = service-configs.sops-default-format;
            # default-key-file = paths.age-key-file-path;
            default-key-file = paths.age-key-file-user-path; #TODO Manual copy necessary
            user = service-configs.sops-user;
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

}