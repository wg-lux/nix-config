{ pkgs, agl-network-config, ... }: 

let 
    ips = agl-network-config.ips;
    ports = agl-network-config.ports;
    domains = agl-network-config.domains;

    # Should be the preferred way to access the variables
    # Improves maintainability
    services = agl-network-config.services;
    openvpn-config = services.openvpn;
    dnsmasq-config = services.dnsmasq;

    openvpn-host-ip = openvpn-config.host-ip;
    main-nginx-ip = ips.main-nginx;
    tcp = dnsmasq-config.tcp;
    udp = dnsmasq-config.udp;
    domain = openvpn-config.domain;
    intern-suffix = openvpn-config.intern-subdomain-suffix;

    domain-intern = "${intern-suffix}.${domain}";
    vpn-subnet = "${ips.openvpn-subnet}/${ips.openvpn-subnet-suffix}";

in
    {
        networking.firewall.allowedTCPPorts = tcp;
        networking.firewall.allowedUDPPorts = udp;

        services.dnsmasq = {
            enable = true;
            settings = {
                # no-resolv = true;
                server = [
                    # route requests to intern domains to own dns
                    "/*${domain-intern}/${openvpn-host-ip}"

                    # For all other Requests:
                    "8.8.8.8"
                    "1.1.1.1" 
                ];

                domain = "${domain-intern},${vpn-subnet},local";
                address = "/*${domain-intern}/${main-nginx-ip}"; # Only for intern.endo-reg.net domains    

                ##### if not provided, we listen on all adresses 
                # listen-address= "::1,127.0.0.1,192.168.1.1";                                  
                # interface = openvpn_network_interface;
            };
        };


    }