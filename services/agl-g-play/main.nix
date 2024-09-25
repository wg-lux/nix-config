{
  config, pkgs, lib,
  agl-network-config,
  ...
}:
let
    hostname = config.networking.hostName;
    custom-config-path = ../../config + ("/${config.networking.hostName}");
    custom-g-play-config-path = custom-config-path + ("/agl-g-play-config.json");
    agl-g-play-config = agl-network-config.services.agl-g-play;
    agl-g-play-secret-path = ../../secrets + ("/" +"${hostname}" + "/services/agl-g-play.yaml");

in 
{
    imports = [
    ];

    sops.secrets."services/agl-g-play/vue-secret-key" = {
        sopsFile = agl-g-play-secret-path;
        path = "${agl-g-play-config.working-directory}/.env/secret";
        format = "yaml";
        owner = config.users.users.agl-admin.name;
    };

    networking.firewall.allowedTCPPorts = [ agl-g-play-config.port ];

    services.agl-g-play = {
        enable = true;
        working-directory = agl-g-play-config.working-directory;
        user = agl-g-play-config.user;
        bind = agl-g-play-config.ip;
        group = agl-g-play-config.group;
    };

    environment.etc."agl-g-play/config.json".source = custom-g-play-config-path;
}