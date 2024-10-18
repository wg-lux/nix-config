let 
    main-config = {
        domains = import ./domains.nix;
        ips = import ./ips.nix;
        ports = import ./ports.nix;
        paths = import ./paths.nix;
        service-configs = import ./service-configs.nix;
        hardware = import ./hardware.nix;
        users = import ./users.nix;
        groups = import ./groups.nix;
        hostnames = import ./hostnames.nix;
        hosts = import ./hosts.nix;
    };

in main-config