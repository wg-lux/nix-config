let 
    ips = import ../ips.nix;
    ports = import ../ports.nix;

in {
    tcp = [ports.dnsmasq.client-tcp];
    udp = [ports.dnsmasq.client-udp];
}