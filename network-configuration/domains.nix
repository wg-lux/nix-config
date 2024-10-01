let

    hostnames = import ./hostnames.nix;

    main-domain = "endoreg.net";
    intern-subdomain-suffix = "intern"; # i.e., all domains like *intern.endo-reg.net

    nextcloud-domain-prefix = "nextcloud-${intern-subdomain-suffix}";
    nextcloud-public-domain = "${nextcloud-domain-prefix}.${main-domain}";
    ldap-domain = "ldap.${main-domain}";
    grafana-domain = "grafana.${main-domain}";

    s01 = hostnames.server-01;
    s02 = hostnames.server-02;
    s03 = hostnames.server-03;
    s04 = hostnames.server-04;
    gc-dev = hostnames.gpu-client-dev;
    gc01 = hostnames.gpu-client-01;
    gc02 = hostnames.gpu-client-02;
    gc03 = hostnames.gpu-client-03;
    gc04 = hostnames.gpu-client-04;
    gc05 = hostnames.gpu-client-05;


in
{
    # Domains
    main-domain = main-domain;
    intern-subdomain-suffix = intern-subdomain-suffix;
    
    clients = {
        "${s01} = "${s01}.${main-domain}";
        "${s02} = "${s02}.${main-domain}";
        "${s03} = "${s03}.${main-domain}";
        "${s04} = "${s04}.${main-domain}";
        "${gc-dev} = "${gc-dev}.${main-domain}";
        "${gc01} = "${gc01}.${main-domain}";
        "${gc02} = "${gc02}.${main-domain}";
        "${gc03} = "${gc03}.${main-domain}";
        "${gc04} = "${gc04}.${main-domain}";
        "${gc05} = "${gc05}.${main-domain}";
    };
    
    nextcloud-public-domain = nextcloud-public-domain;
    ldap-domain = ldap-domain;
    grafana-domain = grafana-domain;

    # URLS
    nextcloud-public-url = "https://${nextcloud-public-domain}/";
    ldap-url = "https://${ldap-domain}";
    grafana-url = "https://${grafana-domain}/";

    
}