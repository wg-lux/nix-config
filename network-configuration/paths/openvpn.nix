let 
    base-paths = import ./base.nix;
    identity-paths = import ./identity.nix;
    custom-logs-config = import ../custom-services/custom-logs.nix;

    prefix = "openvpn-aglNet";
    prefix-underscore = "openvpn_aglNet";

    root = "/etc/${prefix}";
    client-config-file = "aglNet.conf";
    host-config-file = "aglNetHost.conf";
    update-resolv-conf = "update-resolv-conf";
    cert-dir = identity-paths.openvpn-cert-path;

    _log-root = base-paths.default.paths.custom-logs-dir;
    log-root = "${_log-root}/${prefix}";
    log-filename = "openvpn-aglNet-log.csv";
    error-log-filename = "openvpn-aglNet-error.log";

    openvpn-config-source-dir = base-paths.default.paths.etc-source-dir + "/openvpn";
    openvpn-cert-source-dir = base-paths.default.paths.etc-source-dir + "/openvpn-cert";
    openvpn-cert-init-file = openvpn-cert-source-dir + "/init";

in {
    prefix = prefix;
    prefix-underscore = prefix-underscore;

    root = root;

    config-filenames = {
        client = client-config-file;
        host = host-config-file;
    };

    config-filepaths = {
        client = openvpn-config-source-dir + ("/" + client-config-file);
        host = openvpn-config-source-dir + ("/" + host-config-file);
    };

    cert-dir = cert-dir;
    cert-init-file = cert-dir + "/init";

    logs = {
        root = log-root;
        log-filename = log-filename;
        error-log-filename = error-log-filename;
        log-filepath = "${log-root}/${log-filename}";
        errorlog-filepath = "${log-root}/${error-log-filename}";
    };
    
    targets = {
        cert-init-file = cert-init-file;
        client-config-file = client-config-file;
        host-config-file = host-config-file;

        server-crt = cert-dir + "/server.crt";
        server-key = cert-dir + "/server.key";
        dh-pem = cert-dir + "/dh.pem";
    }

    sources = {
        client-config-file = openvpn-config-source-dir + ("/" + client-config-file);
        host-config-file = openvpn-config-source-dir + ("/" + host-config-file);
        update-resolv-conf = openvpn-config-source-dir + ("/" + update-resolv-conf);
        
        ccd-dir = openvpn-config-source-dir + "/ccd";

        config-dir = openvpn-config-source-dir;
        cert-dir = openvpn-cert-source-dir;
        cert-init-file = openvpn-cert-init-file;
    };

    sops-files = {
        shared = base-paths.sops.sources.openvpn-shared-secrets; # includes ta.key and ca.cert
        # host is added @custom-services/openvpn
    };

    sops-targets = {
        server-ta-key = base-paths.sops.targets.openvpn-shared-ta-key;
        ca-cert = base-paths.sops.targets.openvpn-shared-ca-cert;
        host-dh-pem = base-paths.sops.targets.openvpn-host-dh-pem;
        host-server-cert = base-paths.sops.targets.openvpn-host-server-cert;
        host-server-key = base-paths.sops.targets.openvpn-host-server-key;
    }

    

}