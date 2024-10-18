let

    hostnames = import ./hostnames.nix;

    main-domain = "endoreg.net";
    intern-subdomain-suffix = "intern"; # i.e., all domains like *intern.endo-reg.net

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


    # Keycloak
    keycloak.domain = "keycloak.${main-domain}";
    keycloak.url = "https://${keycloak.domain}/";


    # Endoreg Home
    endoreg-home.domain = "home.${main-domain}";
    endoreg-home.url = "https://${endoreg-home.domain}/";

    # Local Monitor
    monitor-local.domain = "monitor-local.${main-domain}";

in
{
    # Domains
    main-domain = main-domain;
    intern-subdomain-suffix = intern-subdomain-suffix;
    
    keycloak = keycloak;
    endoreg-home = endoreg-home;
    
    clients = {
        "${s01}"= "${s01}-intern.${main-domain}";
        "${s02}"= "${s02}-intern.${main-domain}";
        "${s03}"= "${s03}-intern.${main-domain}";
        "${s04}"= "${s04}-intern.${main-domain}";
        "${gc-dev}" = "${gc-dev}-intern.${main-domain}";
        "${gc01}"= "${gc01}-intern.${main-domain}";
        "${gc02}"= "${gc02}-intern.${main-domain}";
        "${gc03}"= "${gc03}-intern.${main-domain}";
        "${gc04}"= "${gc04}-intern.${main-domain}";
        "${gc05}"= "${gc05}-intern.${main-domain}";
    };
    
}