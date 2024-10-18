let
    paths = import ../paths.nix;
    client-manager-paths = paths.endoreg-client-manager;
    root = client-manager-paths.root;
    tmp-root = client-manager-paths.tmp-root;
    multi-ai-pred-dir = client-manager-paths.multi-ai-pred-dir;
    log-dir = client-manager-paths.log-dir;
    django-logfile-path = client-manager-paths.django-logfile;
    celery-logfile-path = client-manager-paths.celery-logfile;

    ports = import ../ports.nix;
    client-manager-ports = ports.endoreg-client-manager;


    users = import ../users.nix;
    groups = import ../groups.nix;

    user = users.endoreg-client-manager;

    django-debug = true;
    prefix = "endoreg-client-manager";
    prefix-underscore = "endoreg_client_manager";
    deployment-mode = "prod";
    django-settings = "${prefix-undercore}.settings"; #_${deployment-mode}";
    log-level = "INFO";
in
{
    root = endoreg-client-manager-base-dir;
    tmp-dir = ecm-tmp-dir;
    paths = client-manager-paths;

    sensitive-data-storage = sensitive-data-storage;

    db = {
        base.path = "${paths.endoreg-client-manager-base-dir}/db.sqlite3";
        sensitive.path = "${paths.sensitive-data-storage.processing-mountpoint}/db.sqlite3";
        processed.path = "${paths.sensitive-data-storage.processed-mountpoint}/db.sqlite3";
    }

    django = {
        log-file = django-logfile-path;
        log-level = log-level;
        debug = django-debug;
    };

    celery = {
        log-file = celery-logfile-path;
        log-level = log-level;
        broker-url = paths.ecm-celery-broker-url;
        result-backend = paths.ecm-celery-result-backend;
    };

    center-settings = {
        # is populated in the respective client config or os-config  
    };


    endoreg-client-manager-config = {
        path = paths.endoreg-client-manager-path;
        dropoff-dir = paths.endoreg-client-manager-dropoff-dir;
        pseudo-dir = paths.endoreg-client-manager-pseudo-dir;
        processed-dir = paths.endoreg-client-manager-processed-dir;
        django-debug = service-configs.endoreg-client-manager-django-debug;
        django-settings-module = service-configs.endoreg-client-manager-django-settings-module;
        user = service-configs.base-service-user;
        group = service-configs.endoreg-client-pseudo-access-group;
        redis-port = ports.endoreg-client-manager-redis-port;
        port = ports.endoreg-client-manager-port;
        agl-anonymizer-port = ports.agl-anonymizer-port;
        agl-anonymizer-dir = paths.agl-anonymizer-dir;
        agl-anonymizer-django-settings-module = service-configs.agl-anonymizer-django-settings-module;
    };
}