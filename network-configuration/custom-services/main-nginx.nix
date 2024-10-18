let 
    domains = import ../domains.nix;
    paths = import ../paths.nix;
    ips = import ../ips.nix;
    ports = import ../ports.nix;
    service-configs = import ../service-configs.nix;

    ssl-cert-path = paths.ssl-certificate-path;
    ssl-cert-key-path = paths.ssl-cert-key-path;

    service-domains = domains.services.domains;

    default-forceSSL-setting = true;

    keycloak-proxy-pass = "http://${ips.localhost-ip}:${toString ports.keycloak.host-https}";
    endoreg-home-proxy-pass = "http://${ips.localhost-ip}:${toString ports.agl-home-django.host-https}";

    all-extraConfig = ''
        proxy_headers_hash_bucket_size 128;
    '';

    aglNetIntern-extraConfig = '' # was intern-endoreg-net-extraConfig
        allow ${ips.vpn-subnet}; 
        deny all;
    '';

    

in {
    recommendedGzipSettings = true;
    recommendedOptimisationSettings = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

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
        "${service-domains.keycloak}" = {
            forceSSL = default-forceSSL-setting;
            sslCertificate = ssl-cert-path;
            sslCertificateKey = ssl-cert-key-path;
            locations = {
                "/" = {
                    proxyPass = keycloak-proxy-pass;
                    extraConfig = all-extraConfig;
                };
            };
        };

        "${service-domains.endoreg-home}" = {
            forceSSL = default-forceSSL-setting;
            sslCertificate = ssl-cert-path;
            sslCertificateKey = ssl-cert-key-path;
            locations = {
                "/" = {
                    proxyPass = endoreg-home-proxy-pass;
                    extraConfig = all-extraConfig; # + aglNetIntern-extraConfig if only internal traffic
                };
            };
        };
    };
}