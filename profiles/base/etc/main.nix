{ config, pkgs, agl-network-config, ...}:

let 
    hostname = config.networking.hostName;
    hostname-path = agl-network-config.paths.etc.hostname;

    openvpn-config = agl-network-config.services.openvpn;
    service-user = agl-network-config.service-configs.service-user;
    service-group = agl-network-config.service-configs.service-group;

    custom-log-dir-init-file = agl-network-config.custom-logs.dir-init-file;

in
    {
        environment.etc."${hostname-path}" = {
            text = hostname;
        };

        imports = [
        ];

    }