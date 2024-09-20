{ config, pkgs, openvpn-config, ...}:

let 
    hostname = config.networking.hostName;

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