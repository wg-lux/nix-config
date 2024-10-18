let 
    domains = import ./domains.nix;
    client-domains = domains.clients;

    ips = import ./ips.nix;
    client-ips = ips.clients;

    # Create the `hosts` attribute set by iterating over the `ips`
    hosts = mapAttrs (hostname: ip: {
        inherit (clients) hostname;
        "${ip}" = [ (clients.${hostname}) hostname ];
    }) ips;

    # create hosts by adding localhost to the hosts
    finalHosts = hosts // {
        "127.0.0.1" = [ "localhost" "localhost" ];
    };


in finalHosts
