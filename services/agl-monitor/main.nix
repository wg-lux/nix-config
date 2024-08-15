{
    config, pkgs, lib, 
    agl-network-config,
    ...
}:

let
    hostname = config.networking.hostName;
    custom-config-path = ../../config + ("/${config.networking.hostName}");
    custom-client-manager-config-path = custom-config-path + ("/agl-monitor.json");
    agl-monitor-secret-path = ../../secrets + ("/" +"${hostname}" + "/services/agl-monitor.yaml");
    agl-monitor-config = agl-network-config.services.agl-monitor;

in
    {
        imports = [
        ];

        sops.secrets."services/agl-monitor/secret-key" = {
            sopsFile = agl-monitor-secret-path;
            path = "${agl-monitor-config.path}/.env/secret";
            format = "yaml";
            owner = config.users.users.agl-admin.name;
        };

        networking.firewall.allowedTCPPorts = [ agl-network-config.services.agl-monitor.port ];

        services.agl-monitor = {
            enable = true;
            working-directory = agl-monitor-config.path;
            user = agl-monitor-config.user;
            bind = agl-monitor-config.ip;
            django-port = agl-monitor-config.port;
            group = agl-monitor-config.group;
            redis-bind = agl-monitor-config.redis-bind;
            redis-port = agl-monitor-config.redis-port;
            django-debug = agl-monitor-config.django-debug;
            django-settings-module = agl-monitor-config.django-settings-module;
        };

        environment.etc."agl-monitor/config.json".source = custom-client-manager-config-path;
    }