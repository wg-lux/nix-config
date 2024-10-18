let
    users = import ../users.nix;
    groups = import ../groups.nix;
    ports = import ../ports.nix;
    domains = import ../domains.nix;
    ips = import ../ips.nix;

    user = users.nextcloud;
    group = groups.nextcloud;
    db-name = "nextcloud";
    db-type = "mysql";
in {
    user = user;
    group = group;

    db = {
        name = db-name;
        type = db-type;
    };

    ports = ports.nextcloud;
    ips = ips.nextcloud;
    domain = domains.nextcloud-public-domain;
}