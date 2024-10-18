let
    hostnames = import ../hostnames.nix;
    users = import ../users.nix;
    groups = import ../groups.nix;
    domains = import ../domains.nix;
    paths = import ../paths.nix;

    network-interface = "tun0";
    user = users.openvpn;
    secret-filemode = "0600";
    host = hostnames.s01;

    
    service-name = "openvpn-aglNet";

    paths = paths.openvpn;
    log-paths = paths.logs;

    # add sops-secret file which is dependent on hostname
    sops-secret-file = paths.base.default.paths.secret-source-root + "/${host}/services/openvpn-aglNet.yaml";
    
    paths.sops.sources.openvpn-secrets = sops-secret-file;
    # ../secrets + ("/" + "${hostname}/services/openvpn-aglNet.yaml");

in {
    domain = domains.main-domain;
    service-name = service-name;
    network-interface = network-interface;
    secret-filemode = "0600";
    public-filemode = "0644";

    user = user;
    group = groups.openvpn;

    cert-mode = secret-filemode;
    network-interface = network-interface;
    host = host;
    
    service-name = service-name;

    ports = ports.openvpn;
    ips = ips.openvpn;
    paths = paths.openvpn;
    
    logger-config = {
        dir = log-paths.root;
        
        log-filename = log-paths.log-filename;
        log-filepath = log-paths.log-filepath;

        errorlog-filename = log-paths.error-log-filename;
        errorlog-filepath = log-paths.errorlog-filepath;
        
        clear-log-script-name = custom-logs-config.clear-logs-script-name;

        user = custom-logs-config.owner;
        group = custom-logs-config.group;

        log-script-name = custom-logs-config.openvpn-custom-log-script-name;

        timer = custom-logs-config.timers.openvpn-logger;

        ping-vpn = custom-logs-config.ping-vpn;
        ping-www = custom-logs-config.ping-www;
    };

}