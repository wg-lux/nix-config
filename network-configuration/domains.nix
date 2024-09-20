let
    main-domain = "endoreg.net";
    intern-subdomain-suffix = "intern"; # i.e., all domains like *intern.endo-reg.net

    nextcloud-public-domain = "nextcloud.${main-domain}";
    ldap-domain = "ldap.${main-domain}";
    grafana-domain = "grafana.${main-domain}";
in
{
    # Domains
    main-domain = main-domain;
    intern-subdomain-suffix = intern-subdomain-suffix;
    
    nextcloud-public-domain = nextcloud-public-domain;
    ldap-domain = ldap-domain;
    grafana-domain = grafana-domain;

    # URLS
    nextcloud-public-url = "https://${nextcloud-public-domain}";
    ldap-url = "https://${ldap-domain}";
    grafana-url = "https://${grafana-domain}/";
}