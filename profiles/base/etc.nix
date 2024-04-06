{ config, pkgs, ...}:

let 
    hostname = config.networking.hostName;

in
    {
        environment.etc."endoreg-client-config/hostname" = {
            text = hostname;
        };
    }