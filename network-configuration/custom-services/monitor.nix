let 

    ips = import ../ips.nix;
    users = import ../users.nix;
    groups = import ../groups.nix;
    ports = import ../ports.nix;
    paths = import ../paths.nix;
    domains = import ../domains.nix;

    user = users.logging-user;
    group = groups.logging-user;

    localhost-ip = ips.localhost-ip;

    prefix = "agl-monitor";
    prefix-underscore = "agl_monitor";
    deploy-mode = "prod";
    django-debug = true;
    django-settings-module = "${prefix-underscore}.settings_${deploy-mode}";

    redis-bind = localhost-ip;

in {
    prefix = prefix;
    prefix-underscore = prefix-underscore;
    deploy-mode = deploy-mode;

    user = user;
    group = group;

    django = {
        debug = django-debug;
        settings-module = django-settings-module;
    };

    redis = {
        bind = redis-bind;
    };

    ips = ips-monitor;
    ports = ports.monitor;
    paths = paths.monitor;
    domains = domains.monitor;

    conf = {
        CACHES = {
            "default" = {
                BACKEND = "django_redis.cache.RedisCache";
                LOCATION = "redis://localhost:${ports.agl-monitor-redis-port}/0";
                TIMEOUT = "300";
                OPTIONS = {
                    "CLIENT_CLASS" = "django_redis.client.DefaultClient";
                };
            };
        };
        CELERY_BROKER_URL = "redis://localhost:${ports.agl-monitor-redis-port}/0";
        CELERY_RESULT_BACKEND = "redis://localhost:${ports.agl-monitor-redis-port}/0";
        CELERY_ACCEPT_CONTENT = "application/json";
        CELERY_TASK_SERIALIZER = "json";
        CELERY_RESULT_SERIALIZER = "json";
        CELERY_TIMEZONE = "UTC";
        CELERY_BEAT_SCHEDULER = "django_celery_beat.schedulers:DatabaseScheduler";

        CELERY_SIGNAL_LOGFILE = paths.agl-monitor-celery-signal-logfile;
    };
}