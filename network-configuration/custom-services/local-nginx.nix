let 
    ips = import ../ips.nix;
    ports = import ../ports.nix;

in {
    ip = ips.localhost-ip;
    port = ports.local-nginx-port;
}