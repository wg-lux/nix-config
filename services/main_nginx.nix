{ 
    pkgs, 
    agl-network-config,
    ... 
}:
let
  # sslCertificatePath = "/etc/endoreg-cert/__endo-reg_net_chain.pem";
  # sslCertificateKeyPath = "/etc/endoreg-cert/endo-reg-net-lower-decrypted.key";

  all-extraConfig = ''
    proxy_headers_hash_bucket_size 128;
  '';
  intern-endoreg-net-extraConfig = ''
    allow 172.16.255.0/24; # Refactor
    deny all;
  '';

  nextcloud-domain = agl-network-config.services.nextcloud.domain;
  nextcloud-public-url = agl-network-config.services.nextcloud.public-url;
  nextcloud-port = toString agl-network-config.services.nextcloud.port;
    

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

      # Nextcloud
      # "${nextcloud-domain}" = {
        "nextcloud-intern.endo-reg.net" = {
        forceSSL = true;
        sslCertificate = sslCertificatePath;
        sslCertificateKey = sslCertificateKeyPath;
        locations."/" = {
          proxyPass = "http://${agl-network-config.services.nextcloud.ip}:80";
          # proxyPass = "http://agl-server-02-intern.endo-reg.net/nextcloud";
          extraConfig = all-extraConfig;# + intern-endoreg-net-extraConfig; #+ ''
          #   # proxy_set_header Upgrade $http_upgrade;
          #   # proxy_set_header Connection "upgrade";

          #   # Enable CORS for Nextcloud
          #   add_header 'Access-Control-Allow-Origin' '*';
          #   add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, PUT, DELETE';
          #   add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization, X-Requested-With, X-CSRF-Token, X-Auth-Token, X-Frame-Options, X-Real-IP, X-Forwarded-For, X-Forwarded-Host, X-Forwarded-Proto';
          #   add_header 'Access-Control-Expose-Headers' 'Content-Security-Policy, Location';
          #   add_header 'Access-Control-Allow-Credentials' 'true';

          #   # Handle preflight requests
          #   if ($request_method = 'OPTIONS') {
          #     add_header 'Access-Control-Allow-Origin' '*';
          #     add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, PUT, DELETE';
          #     add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization, X-Requested-With, X-CSRF-Token, X-Auth-Token, X-Frame-Options, X-Real-IP, X-Forwarded-For, X-Forwarded-Host, X-Forwarded-Proto';
          #     add_header 'Access-Control-Max-Age' 1728000;
          #     add_header 'Content-Length' 0;
          #     add_header 'Content-Type' 'text/plain charset=UTF-8';
          #     return 204;
          #   }
          # '';
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
          proxyPass = "http://${agl-network-config.services.agl-home-django.ip}:${toString agl-network-config.services.agl-home-django.port}";
          extraConfig = all-extraConfig;
        };
      };

      "agl-monitor-intern.endo-reg.net" = {
        forceSSL = true;
        sslCertificate = sslCertificatePath;
        sslCertificateKey = sslCertificateKeyPath;
        locations."/" = {
          proxyPass = "http://${agl-network-config.services.agl-monitor.host-ip}:${toString agl-network-config.services.agl-monitor.host-port}";
          extraConfig = all-extraConfig + intern-endoreg-net-extraConfig;
        };
      };
    };
  };
}
