{ 
    pkgs, 
    agl-network-config,
    # local-nginx-port,
    # grafanaIP, grafanaPort, 
    # endoRegHomeIP, endoRegHomePort,
    # agl-nas-02-ip, synology-dsm-port,
    # synology-drive-ip, synology-drive-port,
    # synology-chat-ip, synology-chat-port,
    # synology-video-ip, synology-video-port,
    ... 
}:
let
  sslCertificatePath = "/etc/endoreg-cert/__endo-reg_net_chain.pem";
  sslCertificateKeyPath = "/etc/endoreg-cert/endo-reg-net-lower-decrypted.key";

  all-extraConfig = ''
    proxy_headers_hash_bucket_size 128;
  '';
  intern-endoreg-net-extraConfig = ''
    allow 172.16.255.0/24; 
    deny all;
  '';

in
{

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true; # Enhanced TLS settings for security
    # Global proxy settings
    appendHttpConfig = ''
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-Host $host;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_ssl_server_name on;
      proxy_pass_header Authorization;
    '';

    virtualHosts = {
      "agl-gpu-client-dev-intern.endo-reg.net" = {
        forceSSL = true;
        sslCertificate = sslCertificatePath;
        sslCertificateKey = sslCertificateKeyPath;
        locations = {

          "/" = {
            proxyPass = "http://${agl-network-config.ips.agl-gpu-client-dev}:${toString agl-network-config.services.local_nginx.port}";
            # proxyPass = "http://${agl-network-config.ips.agl-gpu-client-dev}/";
            proxyWebsockets = true;
            extraConfig = all-extraConfig + intern-endoreg-net-extraConfig;
          };

        };
      };
      "agl-public-nas.endo-reg.net" = {
        forceSSL = true;
        sslCertificate = sslCertificatePath;
        sslCertificateKey = sslCertificateKeyPath;
        locations."/" = {
          proxyPass = "https://${agl-network-config.services.agl-public-nas.ip}:${toString agl-network-config.services.agl-public-nas.port}";
          extraConfig = all-extraConfig;
        };
      };
      "ldap.endo-reg.net" = {
        forceSSL = true;
        sslCertificate = sslCertificatePath;
        sslCertificateKey = sslCertificateKeyPath;
        locations."/" = {
          proxyPass = "https://${agl-network-config.services.ldap.ip}:${toString agl-network-config.services.ldap.port}";
          extraConfig = all-extraConfig;
        };
      };
      "nas02-dsm-intern.endo-reg.net" = {
        forceSSL = true;
        sslCertificate = sslCertificatePath;
        sslCertificateKey = sslCertificateKeyPath;
        locations."/" = {
          proxyPass = "https://${agl-network-config.services.synology-dsm.ip}:${toString agl-network-config.services.synology-dsm.port}";
          extraConfig = all-extraConfig + intern-endoreg-net-extraConfig;
        };
      };
      "chat-intern.endo-reg.net" = {
        forceSSL = true;
        sslCertificate = sslCertificatePath;
        sslCertificateKey = sslCertificateKeyPath;
        locations."/" = {
          proxyPass = "https://${agl-network-config.services.synology-chat.ip}:${toString agl-network-config.services.synology-chat.port}";
          extraConfig = all-extraConfig + intern-endoreg-net-extraConfig;
        };
      };
      "drive-intern.endo-reg.net" = {
        forceSSL = true;
        sslCertificate = sslCertificatePath;
        sslCertificateKey = sslCertificateKeyPath;
        locations."/" = {
          proxyPass = "https://${agl-network-config.services.synology-drive.ip}:${toString agl-network-config.services.synology-drive.port}";
          extraConfig = all-extraConfig +  intern-endoreg-net-extraConfig;
          proxyWebsockets = true;
        };
        extraConfig = ''
          client_max_body_size 100000M;
        '';
      };
      # "video-intern.endo-reg.net" = {
      #   forceSSL = true;
      #   sslCertificate = sslCertificatePath;
      #   sslCertificateKey = sslCertificateKeyPath;
      #   locations."/" = {
      #     proxyPass = "https://${synology-video-ip}:${toString synology-video-port}";
      #     extraConfig = intern-endoreg-net-extraConfig;
      #   };
      # };
      "keycloak.endo-reg.net" = {
        forceSSL = true;
        sslCertificate = sslCertificatePath;
        sslCertificateKey = sslCertificateKeyPath;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080"; # TODO FIXME
          extraConfig = all-extraConfig;
        };
      };

      "grafana.endo-reg.net" = {
        forceSSL = true;
        sslCertificate = sslCertificatePath;
        sslCertificateKey = sslCertificateKeyPath;
        locations."/" = {
          proxyPass = "http://${agl-network-config.services.grafana.ip}:${toString agl-network-config.services.grafana.port}";
          extraConfig = all-extraConfig;
        };
      };

      "home.endo-reg.net" = {
        forceSSL = true;
        sslCertificate = sslCertificatePath;
        sslCertificateKey = sslCertificateKeyPath;
        locations."/" = {
          proxyPass = "http://${agl-network-config.services.endoreg-home.ip}:${toString agl-network-config.services.endoreg-home.port}";
          extraConfig = all-extraConfig;
        };
      };
    };
  };
}
