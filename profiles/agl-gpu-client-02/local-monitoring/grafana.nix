{ 
    config, ip,
    port,
    ...
}:

{
    # grafana: port 3010 (8010)
    services.grafana = {
        enable = true;
        settings = {
            analytics = {
                reporting_enabled = false;
                feedback_links_enabled = false;
            };
            server = {
                # WARNING: this should match nginx setup!
                # prevents "Request origin is not authorized"
                root_url = "https://agl-gpu-client-dev-intern.endo-reg.net/grafana/"; # helps with nginx / ws / live
                serve_from_sub_path = true;
                # http_addr = ip;
                http_addr = "127.0.0.1";
                http_port = port;
                enable_gzp = true;
                # protocol = "https";
            };
        };

        provision = {
            enable = true;
            datasources.settings.datasources = [
                {
                    name = "Prometheus";
                    type = "prometheus";
                    access = "proxy";
                    url = "http://127.0.0.1:${toString config.services.prometheus.port}";
                }
                {
                    name = "Loki";
                    type = "loki";
                    access = "proxy";
                    url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
                }
            ];
        };
    };
}