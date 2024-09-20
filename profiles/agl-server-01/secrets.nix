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
        
    }