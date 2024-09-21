let
    vpn-ip-prefix = "172.16.255";

    ## Servers
    agl-server-01 = "${vpn-ip-prefix}.1";
    agl-server-01-local = "192.168.179.18";
    agl-server-02 = "${vpn-ip-prefix}.2";
    agl-server-03 = "${vpn-ip-prefix}.3";
    agl-server-04 = "${vpn-ip-prefix}.4";

    agl-nas-01 = "${vpn-ip-prefix}.120";
    agl-nas-02 = "${vpn-ip-prefix}.121";

    ## Clients
    agl-gpu-client-dev = "${vpn-ip-prefix}.140";
    agl-gpu-client-02 = "${vpn-ip-prefix}.142";
    agl-gpu-client-03 = "${vpn-ip-prefix}.143";
    agl-gpu-client-04 = "${vpn-ip-prefix}.144";
    agl-gpu-client-05 = "${vpn-ip-prefix}.145";

    main-nginx = agl-server-03;

    openvpn-host-ip = agl-server-01;
    openvpn-host-local-ip = agl-server-01-local;
    openvpn-subnet = "${vpn-ip-prefix}.0";
    openvpn-subnet-suffix = "32";

in
{
    vpn-ip-prefix = vpn-ip-prefix;

    agl-server-01 = agl-server-01;
    agl-server-02 = agl-server-02;
    agl-server-03 = agl-server-03;
    agl-server-04 = agl-server-04;

    agl-nas-01 = agl-nas-01;
    agl-nas-02 = agl-nas-02;

    agl-gpu-client-dev = agl-gpu-client-dev;
    agl-gpu-client-02 = agl-gpu-client-02;
    agl-gpu-client-03 = agl-gpu-client-03;
    agl-gpu-client-04 = agl-gpu-client-04;
    agl-gpu-client-05 = agl-gpu-client-05;


    ## Services
    ### S01
    openvpn-host-ip = openvpn-host-ip;
    openvpn-host-local-ip = openvpn-host-local-ip;
    openvpn-subnet = openvpn-subnet;
    openvpn-subnet-suffix = openvpn-subnet-suffix;

    ### S02

    ### S03
    main-nginx = main-nginx;

    ### S04
    nextcloud = agl-server-04;
    nextcloud-proxy = main-nginx;
    agl-home-django = agl-server-04;

    ### NAS02
    synology-service = agl-nas-02;
    synology-drive = agl-nas-02;
    synology-chat = agl-nas-02;
    synology-video = agl-nas-02;

}