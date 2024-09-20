{ ... }:
{



  #

  



  # nginx reverse proxy
  services.nginx = {
    enable = false;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    # recommendedTlsSettings = true;

    upstreams = {
      "grafana" = {
        servers = {
          "127.0.0.1:${toString config.services.grafana.settings.server.http_port}" = {};
        };
      };
      "prometheus" = {
        servers = {
          "127.0.0.1:${toString config.services.prometheus.port}" = {};
        };
      };
      "loki" = {
        servers = {
          "127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}" = {};
        };
      };
      "promtail" = {
        servers = {
          "127.0.0.1:${toString config.services.promtail.configuration.server.http_listen_port}" = {};
        };
      };
    };

    virtualHosts.grafana = {
      locations."/" = {
        proxyPass = "http://grafana";
        proxyWebsockets = true;
      };
      listen = [{
        addr = "192.168.1.10";
        port = 8010;
      }];
    };

    virtualHosts.prometheus = {
      locations."/".proxyPass = "http://prometheus";
      listen = [{
        addr = "192.168.1.10";
        port = 8020;
      }];
    };

    # confirm with http://192.168.1.10:8030/loki/api/v1/status/buildinfo
    #     (or)     /config /metrics /ready
    virtualHosts.loki = {
      locations."/".proxyPass = "http://loki";
      listen = [{
        addr = "192.168.1.10";
        port = 8030;
      }];
    };

    virtualHosts.promtail = {
      locations."/".proxyPass = "http://promtail";
      listen = [{
        addr = "192.168.1.10";
        port = 8031;
      }];
    };
  };

}