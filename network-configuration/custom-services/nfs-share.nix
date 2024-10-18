let 
    _ips = import ../ips.nix;
    ips = _ips.nfs-share;

    _ports = import ../ports.nix;
    ports = _ports.nfs-share;

    _paths = import ../paths.nix;
    paths = _paths.nfs-share;

in {

}