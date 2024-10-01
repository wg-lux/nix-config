{   
    config, pkgs,
    ip, agl-network-config,
    ...
}:

# MONITORING: services run on loopback interface
#             nginx reverse proxy exposes services to network
#             - grafana:3010
#             - prometheus:3020
#             - loki:3030
#             - promtail:3031

let
    local-nginx-port = agl-network-config.services.local_nginx.port;
    service-net-conf = agl-network-config.services.local-monitoring;
    lm-grafana-port = service-net-conf.grafana-port;
    lm-prometheus-port = service-net-conf.prometheus-port;
    lm-prometheus-node-exporter-port = service-net-conf.prometheus-node-exporter-port;
    lm-promtail-port = service-net-conf.promtail-port;
    lm-loki-port = service-net-conf.loki-port;

    restrict-access-extraConfig = ''
        allow 127.0.0.1;
        allow ${agl-network-config.services.main_nginx.ip};
        allow ${ip};
        deny all;
    '';

    hostname = config.networking.hostName;
in

{

    imports = [
        ( import ./grafana.nix {
            inherit config ip;
            port = lm-grafana-port;
            }
        )
        ( import ./promtail.nix {
            inherit config;
            port = lm-promtail-port;
            }
        )
        ( import ./prometheus.nix {
            inherit config;
            port = lm-prometheus-port;
            node-exporter-port = lm-prometheus-node-exporter-port;
            }
        )
        ( import ./loki.nix {
            inherit config;
            port = lm-loki-port;
            }
        )
        # (
        #   import ./telegraf.nix {
        #     inherit config pkgs hostname;
        #   }
        # )
    ];

    # Enable Telegraf
    # services.telegraf.enable = true;

    # # nginx must be up and configured, in most cases "local-nginx.nix" should be imported
    services.nginx.defaultListen = [
        { addr = "${config.networking.hostName }-intern.endo-reg.net"; port = local-nginx-port; }
    ];
    services.nginx.virtualHosts = {

        ### internal usage
        "${hostname}-intern.endo-reg.net" = {
            # listen = [
            #     { addr = ip; port = local-nginx-port; }
            # ];
            locations = {
                "/grafana/" = {
                    proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
                    proxyWebsockets = true;
                    extraConfig = restrict-access-extraConfig;
                };
                "/prometheus/" = {
                    proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
                    extraConfig = restrict-access-extraConfig;
                };
                "/loki/" = {
                    proxyPass = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
                    extraConfig = restrict-access-extraConfig;
                };
                "/promtail/" = {
                    proxyPass = "http://127.0.0.1:${toString config.services.promtail.configuration.server.http_listen_port}";
                    extraConfig = restrict-access-extraConfig;
                };
            };
            # listen = [{}]; default definition in "local-nginx.nix" ${ip}:{local-nginx-port};
        };
    };

}