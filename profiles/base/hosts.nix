{agl-network-config, ...} @inputs:
let
    hostnames = agl-network-config.hostnames;
    domains = agl-network-config.domains;
    client-domains = domains.clients;

    s01 = hostnames.server-01;
    s02 = hostnames.server-02;
    s03 = hostnames.server-03;
    s04 = hostnames.server-04;
    gc-dev = hostnames.gpu-client-dev;
    gc01 = hostnames.gpu-client-01;
    gc02 = hostnames.gpu-client-02;
    gc03 = hostnames.gpu-client-03;
    gc04 = hostnames.gpu-client-04;
    gc05 = hostnames.gpu-client-05;

    ips = agl-network-config.ips;
    s01-ip = ips.server-01;
    s02-ip = ips.server-02;
    s03-ip = ips.server-03;
    s04-ip = ips.server-04;
    gc-dev-ip = ips.gpu-client-dev;
    gc01-ip = ips.gpu-client-01;
    gc02-ip = ips.gpu-client-02;
    gc03-ip = ips.gpu-client-03;
    gc04-ip = ips.gpu-client-04;
    gc05-ip = ips.gpu-client-05;


in {
    networking.hosts = {
        # AGL S01
        "${s01-ip}" = [
            client-domains."${s01}"
        ];

        # AGL S02
        "${s02-ip}" = [
            client-domains."${s02}"
        ];

        # AGL S03
        "${s03-ip}" = [
            client-domains."${s03}"
        ];

        # AGL S04
        "${s04-ip}" = [
            client-domains."${s04}"
        ];

        # AGL GC DEV
        "${gc-dev-ip}" = [
            client-domains."${gc-dev}"
        ];

        # AGL GC 01
        "${gc01-ip}" = [
            client-domains."${gc01}"
        ];

        # AGL GC 02
        "${gc02-ip}"= [
            client-domains."${gc02}"
        ];

        # AGL GC 03
        "${gc03-ip}" = [
            client-domains."${gc03}"
        ];

        # AGL GC 04
        "${gc04-ip}" = [
            client-domains."${gc04}"
        ];

        # AGL GC 05
        "${gc05-ip}" = [
            client-domains."${gc05}"
        ];
    };
}