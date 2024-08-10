{
    config, pkgs, lib, 
    agl-home-django-config,
    ...
}:

let
    hostname = config.networking.hostName;
    custom-config-path = ../../config + ("/${config.networking.hostName}");
    custom-client-manager-config-path = custom-config-path + ("/agl-home-django.json");
    

in
    {
        imports = [
        ];

        services.agl-home-django = {
            enable = true;
            working-directory = agl-home-django-config.path;
            user = agl-home-django-config.user;
            group = agl-home-django-config.group;
            redis-port = agl-home-django-config.redis-port;
            django-debug = agl-home-django-config.django-debug;
            django-settings-module = agl-home-django-config.django-settings-module;
        };
        
        environment.etc."agl-home-django/agl-home-django.json".source = custom-client-manager-config-path;
    }