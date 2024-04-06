{   
    agl-network-config,
    ...
}:
let 
    port = agl-network-config.services.local_nginx.port;
in
{

    # set necessary firewall rules
    networking.firewall.allowedTCPPorts = [ port ];

    services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        # recommendedTlsSettings = true;


        # Doesnt seem to work? #FIXME
        # defaultListen = [
        #     {
        #         addr = ip;
        #         port = port;
        #     }
        # ];

        # appendHttpConfig = ''
        #     proxy_set_header Host $host;
        #     proxy_set_header X-Forwarded-Host $host;
        #     proxy_set_header X-Forwarded-Proto $scheme;
        #     proxy_set_header X-Real-IP $remote_addr;
        #     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #     proxy_ssl_server_name on;
        #     proxy_pass_header Authorization;
        # '';
    };

}