{ pkgs, network_interface, ... }: 

let 
    local_network_ip = "192.168.179.18";
    openvpn_network_interface = "tun0";
    openvpn_network_ip = "172.16.255.1";
in
    {

        networking.firewall.allowedTCPPorts = [ 53 ];
        networking.firewall.allowedUDPPorts = [ 53 ];
        services.dnsmasq = {
            enable = true;
            settings = {
                # no-resolv = true;
                server = [
                    "/*intern.endo-reg.net/172.16.255.1"
                    "8.8.8.8"
                    "1.1.1.1" 
                ];
                domain = "intern.endo-reg.net,172.16.255.0/32,local";
                # local = "/intern.endo-reg-net/";
                address = "/*intern.endo-reg.net/172.16.255.3"; # Only for intern.endo-reg.net domain    

                ##### if not provided, we listen on all adresses 
                # listen-address= "::1,127.0.0.1,192.168.1.1";                                  
                # interface = openvpn_network_interface;
            };
        };


    }