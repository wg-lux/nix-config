{ lib, openvpn-config, ... }@inputs:
let
    hostname = config.networking.hostName;
    secret-filemode = openvpn-config.secret-filemode;
    public-filemode = openvpn-config.public-filemode;

    prefix = openvpn-config.paths.prefix;

    ### Sources:
    client-config-file-source-path = openvpn-config.paths.sources.client-config-file;
    host-config-file-source-path = openvpn-config.paths.sources.host-config-file;
    update-resolv-conf-source-path = openvpn-config.paths.sources.update-resolv-conf;
    cert-init-file-source-path = openvpn-config.paths.sources.cert-init-file;

    # SECRETS
    ## Sources
    openvpn-shared-secrets-sopsfile = openvpn-config.paths.sops-files.shared;

    ## Targets
    ta-key-target = openvpn-config.paths.secrets.server-ta-key.target;
    ca-cert-target = openvpn-config.paths.secrets.ca-cert.target;

in {
    environment.etc."${prefix}/${client-config-file-name}" = {
        source = client-config-file-source-path;
        user = openvpn-config.user;
        group = openvpn-config.group;
        mode = public-filemode;
    };

    environment.etc."${prefix}/${host-config-file-name}" = {
        source = host-config-file-source-path;
        user = openvpn-config.user;
        group = openvpn-config.group;
        mode = public-filemode;
    };

    environment.etc."${prefix}/${update-resolv-conf-file-name}" = {
        source = update-resolv-conf-source-path;
        user = openvpn-config.user;
        group = openvpn-config.group;
        mode = public-filemode;
    };

    # copy the ccd directory
    environment.etc."${prefix}/ccd" = {
        source = ccd-dir;
        user = openvpn-config.user;
        group = openvpn-config.group;
        mode = "symlink";
    };

    # copy the cert directory
    environment.etc."openvpn-cert/init" = {
        source = cert-config-init-file-source-path;
        user = openvpn-config.user;
        group = openvpn-config.group;
        mode = public-filemode;
    };

    ## Secrets
    sops.secrets."${ta-key-target}" = {
        sopsFile = openvpn-shared-secrets-sopsfile;
        path = "${openvpn-cert-path}/ta.key";
        owner = openvpn-user;
        mode = file-mode;
        group = openvpn-group;
    };
    
    sops.secrets."${ca-cert-target}" = {
        sopsFile = openvpn-shared-secrets-sopsfile;
        path = "${openvpn-cert-path}/ca.crt";
        owner = openvpn-user;
        mode = file-mode;
        group = openvpn-group;
    };
}