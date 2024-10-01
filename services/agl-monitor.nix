{
    config, pkgs, lib, 
    agl-network-config,
    ...
}:

let
    hostname = config.networking.hostName;
    custom-config-path = ../config + ("/${config.networking.hostName}");
    custom-client-manager-config-path = custom-config-path + ("/agl-monitor.json");
    agl-monitor-secret-path = ../secrets + ("/" +"${hostname}" + "/services/agl-monitor.yaml");
    agl-monitor-config = agl-network-config.services.agl-monitor;

    user = agl-monitor-config.user;
    group = agl-monitor-config.group;
    user-dir = agl-monitor-config.user-dir;
    service-dir = agl-monitor-config.monitor-dir;

    agl-monitor-setup-script = pkgs.writeShellScriptBin "agl-monitor-pre" ''
        # Ensure the log directory exists
        if [ ! -d "${service-dir}" ]; then
            mkdir -p "${service-dir}"
        fi

        # Ensure the correct owner, group, and permissions
        chown ${user}:${group} "${service-dir}"
        chmod 775 "${service-dir}"
    '';


in
    {
        imports = [
        ];

        environment.systemPackages = with pkgs; [
            agl-monitor-setup-script
        ];

        sops.secrets."services/agl-monitor/secret-key" = {
            sopsFile = agl-monitor-secret-path;
            # path = "${agl-monitor-config.path}/.env/secret";
            format = "yaml";
            owner = config.users.users.agl-admin.name;
        };

        # networking.firewall.allowedTCPPorts = [ agl-network-config.services.agl-monitor.port ];

        # services.agl-monitor = agl-monitor-config;
        services.agl-monitor = {
            enable = true;
            
            user = agl-monitor-config.user;
            group = agl-monitor-config.group;
            user-dir = agl-monitor-config.user-dir;
            service-dir = agl-monitor-config.monitor-dir;
            setup-script = agl-monitor-setup-script;
            setup-script-name = "agl-monitor-pre";

            custom-logs-dir = agl-monitor-config.custom-logs-dir;
            bind = agl-monitor-config.bind;
            django-debug = agl-monitor-config.django-debug; # breaks if true?!  https://discourse.nixos.org/t/packaged-python-application-cannot-be-executed/42656
            django-settings-module = agl-monitor-config.django-settings-module;
            django-port = agl-monitor-config.port;
            django-secret-key = "CHANGE_ME"; # TODO
            redis-port = agl-monitor-config.redis-port;
            redis-bind = agl-monitor-config.redis-bind;

            # conf = 
        };

        # environment.etc."agl-monitor/config.json".source = custom-client-manager-config-path;
    }