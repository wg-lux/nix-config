{ config, pkgs, agl-network-config, ...}:

let 
    hostname = config.networking.hostName;

    openvpn-config = agl-network-config.services.openvpn;
    service-user = agl-network-config.service-configs.service-user;
    service-group = agl-network-config.service-configs.service-group;

    custom-log-dir-init-file = agl-network-config.custom-logs.dir-init-file;

in
    {
        environment.etc."endoreg-client-config/hostname" = {
            text = hostname;
        };

        imports = [
            (import ./openvpn.nix {
                inherit openvpn-config;
            })
        ];

    }