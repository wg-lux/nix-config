{   config,
    openvpnCertPath, # = /home/agl-admin/openvpn-cert
    openvpnConfigPath, # = /home/agl-admin/openvpn-config
    ...
}:

let
    hostname = config.networking.hostName;
    secretPath = ../../secrets + ("/" + "${hostname}/services/openvpn-aglNet.yaml");

in
    {
        sops.secrets."services/openvpn-aglNet/dh-pem" = {
            sopsFile = secretPath;
            path = "${openvpnCertPath}/dh.pem";
            format = "yaml";
            owner = "agl-admin";
        };
        
        sops.secrets."services/openvpn-aglNet/server-cert" = {
            sopsFile = secretPath;
            path = "${openvpnCertPath}/server.crt";
            format = "yaml";
            owner = "agl-admin";
        };

        sops.secrets."services/openvpn-aglNet/server-key" = {
            sopsFile = secretPath;
            path = "${openvpnCertPath}/server.key";
            format = "yaml";
            owner = "agl-admin";
        };
    }