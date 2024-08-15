{
    config, pkgs, lib, 
    agl-home-django-config,
    agl-network-config,
    ...
}:

let
    hostname = config.networking.hostName;
    custom-config-path = ../../config + ("/${config.networking.hostName}");
    custom-client-manager-config-path = custom-config-path + ("/agl-home-django.json");
    agl-home-django-secret-path = ../../secrets + ("/" +"${hostname}" + "/services/agl-home-django.yaml");

in
    {
        imports = [
        ];

    sops.secrets."services/agl-home-django/secret-key" = {
      sopsFile = agl-home-django-secret-path;
      path = "${agl-home-django-config.path}/.env/secret";
      format = "yaml";
      owner = config.users.users.agl-admin.name;
    };

    sops.secrets."services/agl-home-django/keycloak-client-id" = {
      sopsFile = agl-home-django-secret-path;
      path = "${agl-home-django-config.path}/.env/keycloak-client";
      format = "yaml";
      owner = config.users.users.agl-admin.name;
    };

    sops.secrets."services/agl-home-django/keycloak-secret" = {
      sopsFile = agl-home-django-secret-path;
      path = "${agl-home-django-config.path}/.env/keycloak-secret";
      format = "yaml";
      owner = config.users.users.agl-admin.name;
    };

    networking.firewall.allowedTCPPorts = [ agl-home-django-config.port ];


        services.agl-home-django = {
            enable = true;
            working-directory = agl-home-django-config.path;
            user = agl-home-django-config.user;
            django-ip = agl-home-django-config.ip;
            django-port = agl-home-django-config.port;
            group = agl-home-django-config.group;
            redis-port = agl-home-django-config.redis-port;
            django-debug = agl-home-django-config.django-debug;
            django-settings-module = agl-home-django-config.django-settings-module;
        };

        environment.etc."agl-home-django/config.json".source = custom-client-manager-config-path;
    }