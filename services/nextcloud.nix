{config, pkgs, agl-network-config, ...}:

let
    hostname = config.networking.hostName;
    nextcloud-secret-path = ../secrets + ("/" + "${hostname}/nextcloud.yaml");

in
    # https://nixos.org/manual/nixos/stable/index.html#module-services-nextcloud-basic-usage
    # https://nixos.wiki/wiki/Nextcloud

    {
        sops.secrets."services/nextcloud/user/agl-admin/pwd" = {
            sopsFile = nextcloud-secret-path;
        };

        services.nextcloud = {
            enable = true;
            package = pkgs.nextcloud28;
            hostName = hostname;
            https = true;
            config.adminpassFile = config.sops.secrets."services/nextcloud/user/agl-admin/pwd".path;


            # extraApps = {
            #     inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
            # };
            # extraAppsEnable = true;
        };
    }