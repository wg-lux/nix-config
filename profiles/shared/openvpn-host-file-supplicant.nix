{config, openvpn-config, ...}@inputs:
let
    hostname = config.networking.hostName;
    user = openvpn-config.user;
    group = openvpn-config.group;

    secret-filemode = openvpn-config.secret-filemode;
    sops-file = openvpn-config.paths.sops.sources.openvpn-secrets;

    sops-target-dh-pem = openvpn-config.paths.sops-targets.host-dh-pem;
    sops-target-server-cert = openvpn-config.paths.sops-targets.host-server-cert;
    sops-target-server-key = openvpn-config.paths.sops-targets.host-server-key;

    

in {
    sops.secrets."${sops-target-dh-pem}" = {
        sopsFile = sops-file;
        path = "${openvpn-cert-path}/dh.pem";
        format = "yaml";
        mode = secret-filemode;
        owner = user;
    };

    sops.secrets."${sops-target-server-cert}" = {
        sopsFile = sops-file;
        path = "${openvpn-cert-path}/server.crt";
        format = "yaml";
        mode = secret-filemode;
        owner = user;
    };

    sops.secrets."${sops-target-server-key}" = {
        sopsFile = sops-file;
        path = "${openvpn-cert-path}/server.key";
        format = "yaml";
        mode = secret-filemode;
        owner = user;
    };
}