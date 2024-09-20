{ 
    config, port, node-exporter-port, 
    ...
}:

let 
    hostname = config.networking.hostName;

in

{
    services.prometheus = {
        port = port;
        enable = true;
        # webExternalUrl = "http://${hostname}-intern.endo-reg.net/prometheus/"; # FIXME if active, grafana conf. needs to change which would break local usage
        exporters = {
            node = {
                port = node-exporter-port;
                enabledCollectors = [ 
                    "systemd" 
                    # "dcgm" 
                ];
                enable = true;
            };
        };

            # ingest the published nodes
        scrapeConfigs = [{
            job_name = "nodes";
            static_configs = [{
                targets = [
                    "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
                ];
            }];
        }];
    };
}