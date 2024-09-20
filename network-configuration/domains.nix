{
    # Domains
    main-domain = "endoreg.net";

    nextcloud-public-domain = "nextcloud.${main-domain}";
    ldap-domain = "ldap.${main-domain}";
    grafana-domain = "grafana.${main-domain}";

    # URLS
    nextcloud-public-url = "https://${nextcloud-public-domain}";
    ldap-url = "https://${ldap-domain}";
    grafana-url = "https://${grafana-domain}/";
}