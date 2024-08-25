{
  config, pkgs, lib,
  agl-network-config
  ...
}:
let
    hostname = config.networking.hostName;
    custom-config-path = ../../config + ("/${config.networking.hostName}");
    #secret path?
    agl-g-play-config = agl-network-config.services.agl-g-play;
    agl-g-play-secret-path = ../../secrets + ("/" +"${hostname}" + "/services/agl-g-play.yaml");

in 
{
    imports = [
    ];

    sops.secrets."services/agl-g-play/vue-secret-key" = {
        sopsFile = agl-g-play-config.secret-path;
        path = "${agl-g-play-config.path}/.env/secret";
        format = "yaml";
        owner = config.users.users.agl-admin.name;
    };

    networking.firewall.allowedTCPPorts = [ agl-g-play-config.port ];

    services.agl-g-play = {
        enable = true;
        working-directory = agl-g-play-config.path;
        user = agl-g-play-config.user;
        bind = agl-g-play-config.ip;
        django-port = agl-g-play-config.port;
        group = agl-g-play-config.group;
        redis-bind = agl-g-play-config.redis-bind;
        redis-port = agl-g-play-config.redis-port;
        django-debug = agl-g-play-config.django-debug;
        django-settings-module = agl-g-play-config.django-settings-module;
    };

    environment.etc."agl-g-play/config.json".source = custom-client-manager-config-path;
}