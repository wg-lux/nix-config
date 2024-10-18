let
    paths = import ../paths.nix;
    ports = import ../ports.nix;
    domains = import ../domains.nix;
    ips = import ../ips.nix;
    users = import ../users.nix;
    groups = import ../groups.nix;

    prefix = "agl-anonymizer";
    prefix-underscore = "agl_anonymizer";
    deploy-mode = "prod";
    django-debug = true;
    django-settings-module = "${prefix-underscore}.settings";

    user = users.service-user;
    group = groups.service-group;

in {
    prefix = prefix;
    prefix-underscore = prefix-underscore;
    
    user = user;
    group = group;

    django = {
        debug = django-debug;
        settings-module = django-settings-module;
    };

    deployment-mode = deploy-mode;

    paths = paths;
    ports = ports;
    domains = domains;
    ips = ips;

}