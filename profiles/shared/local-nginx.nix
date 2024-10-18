{   
    config, agl-network-config,
    ...
}:
let 
    port = agl-network-config.services.local_nginx.port;
in
{

    # set necessary firewall rules
    networking.firewall.allowedTCPPorts = [ port ];

    services.nginx = {
        # defaultListen = [
        #     { addr = "${config.networking.hostName }-intern.endo-reg.net"; port = port; }
        # ];

        enable = true;
        # recommendedProxySettings = true;
        # recommendedOptimisation = true;
        # recommendedGzipSettings = true;
        # recommendedTlsSettings = true;    

        virtualHosts = {
            # "monitor.local" = {
            #     locations."/" = {
            #     proxyPass = "http://127.0.0.1:9999";
            #     };
            # };
        };
    };

}