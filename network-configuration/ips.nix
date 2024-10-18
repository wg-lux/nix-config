let
    vpn-ip-prefix = "172.16.255";
    vpn-subnet = "${vpn-ip-prefix}.0/24";
    localhost = "localhost";
    localhost-ip = "127.0.0.1";

    hostnames = import ./hostnames.nix;

    ## Clients
    clients = {
        server-01 = "${vpn-ip-prefix}.1";
        server-02 = "${vpn-ip-prefix}.2";
        server-03 = "${vpn-ip-prefix}.3";
        server-04 = "${vpn-ip-prefix}.4";
        gpu-client-dev = "${vpn-ip-prefix}.140";
        gpu-client-01 = "${vpn-ip-prefix}.141";
        gpu-client-02 = "${vpn-ip-prefix}.142";
        gpu-client-03 = "${vpn-ip-prefix}.143";
        gpu-client-04 = "${vpn-ip-prefix}.144";
        gpu-client-05 = "${vpn-ip-prefix}.145";
    };

    by-hostname = {
        "${hostnames.server-01} = "${vpn-ip-prefix}.1";
        "${hostnames.server-02} = "${vpn-ip-prefix}.2";
        "${hostnames.server-03} = "${vpn-ip-prefix}.3";
        "${hostnames.server-04} = "${vpn-ip-prefix}.4";
        "${hostnames.gpu-client-dev} = "${vpn-ip-prefix}.140";
        "${hostnames.gpu-client-01} = "${vpn-ip-prefix}.141";
        "${hostnames.gpu-client-02} = "${vpn-ip-prefix}.142";
        "${hostnames.gpu-client-03} = "${vpn-ip-prefix}.143";
        "${hostnames.gpu-client-04} = "${vpn-ip-prefix}.144";
        "${hostnames.gpu-client-05} = "${vpn-ip-prefix}.145";
    };



    # services

    ## S01
    openvpn = {
        host = openvpn-host-ip;
        # host-local = openvpn-host-local-ip;
        subnet = "${vpn-ip-prefix}.0";
        subnet-suffix = "32";
    };

    ## S02
    monitor = {
        host = clients.server-02;
    };

    nextcloud = {
        host = clients.server-02;
    };
    
    ## S03
    main-nginx = {
        host = clients.server-03;
    };


    nextcloud-host-ip = server-02;

in
{
    localhost = localhost;
    localhost-ip = localhost-ip;
    vpn-ip-prefix = vpn-ip-prefix;
    vpn-subnet = vpn-subnet;

    clients = clients;
    by-hostnames = by-hostname;

    # S01
    openvpn = openvpn;

    # S02
    monitor = monitor;
    nextcloud = nextcloud;

    ### S03
    main-nginx = main-nginx;


}