{...}:
{
    networking.firewall.allowedTCPPorts = [ 53 ];
    networking.firewall.allowedUDPPorts = [ 53 ];

    services.nsd = { 
        enable = true;  
        rootServer = true;
        interfaces = [ "172.16.255.1" ]; # OpenVPN server interface IP

        zones = {
            "intern.endo-reg.net." = {
                data = ''
                    $ORIGIN intern.endo-reg.net. 
                    $TTL    86400

                    @       IN SOA  ns1.intern.endo-reg.net. webmaster.endo-reg.net. (
                                    2024022602 ; serial
                                    3600       ; refresh 
                                    900        ; retry
                                    1209600    ; expire
                                    3600       ; minimum TTL
                                )

                    @       IN NS   ns1.intern.endo-reg.net. 
                    ns1     IN A    172.16.255.1          ; NSD server
                    www     IN A    172.16.255.3          ; Nginx server
                '';
            };

            # Catch-all for other domains, forwarding to external DNS
            "." = {
                forwarders = [ "8.8.8.8" "4.4.4.4" ];  # Google DNS
            };
        };
    };

}