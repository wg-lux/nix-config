{
    config, pkgs, lib, 
    endoreg-client-manager-config,
    ...
}:

let
    hostname = config.networking.hostName;
    endoreg-client-manager-path = endoreg-client-manager-config.path;
    custom-config-path = ../../config + ("/${config.networking.hostName}");
    custom-client-manager-config-path = custom-config-path + ("/client-manager-config.json");


in
    {
        imports = [
            # (import ./client_manager_celery.nix { inherit config pkgs lib endoreg-client-manager-config; })
            # (import ./client_manager_django.nix { inherit config pkgs endoreg-client-manager-config; })
            # # (import ./client_manager_flower.nix { inherit config pkgs endoreg-client-manager-path; })
            # # (import ./mount-processed.nix { inherit config lib pkgs; })

            ( import ../../scripts/endoreg-client/data-mount-dropoff.nix {inherit pkgs config lib hostname;})
            ( import ../../scripts/endoreg-client/data-mount-processed.nix {inherit pkgs config lib hostname;})
            ( import ../../scripts/endoreg-client/data-mount-pseudo.nix {inherit pkgs config lib hostname;})

            ( import ../../scripts/endoreg-client/data-umount-dropoff.nix {inherit pkgs config lib hostname;})
            ( import ../../scripts/endoreg-client/data-umount-pseudo.nix {inherit pkgs config lib hostname;})
            ( import ../../scripts/endoreg-client/data-umount-processed.nix {inherit pkgs config lib hostname;}) 
        ];

        services.endoreg-client-manager = {
            enable = true;
            working-directory = endoreg-client-manager-config.path;
            user = endoreg-client-manager-config.user;
            group = endoreg-client-manager-config.group;
            redis-port = endoreg-client-manager-config.redis-port;
            django-debug = endoreg-client-manager-config.django-debug;
            django-settings-module = endoreg-client-manager-config.django-settings-module;
        };

        environment.etc."endoreg-client-config/hdd.json".source = ../../config/hdd.json;
        environment.etc."endoreg-client-config/multilabel-ai-config.json".source = ../../config/multilabel-ai-config.json;
        environment.etc."endoreg-client-config/endoreg-center-client.json".source = ../../config/endoreg-center-client.json;
        environment.etc."endoreg-client-config/client-manager-config.json".source = custom-client-manager-config-path;

    }