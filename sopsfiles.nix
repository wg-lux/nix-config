{config,...}@inputs:

let 
    hostname = config.networking.hostName;

    secret-root = ./secrets + "/${hostname}";

    sopsfiles = {
        etc-age-keyfile = secret-root + "/age-keys.txt";
        openvpn = sercret-root + "/services/openvpn.yaml";
        openvpn-host = secret-root + "/services/openvpn-host.yaml";
    };

in sopsfiles