let
    base-paths = import ./base.nix;

    prefix = "agl-monitor";
    prefix-underscore = "agl_monitor";

    root = "/etc/${prefix}";
    log-dir-root = base-paths.default.paths.custom-logs-dir;
    log-dir = "${log-dir-root}/${prefix}";

in {
    prefix = prefix;
    prefix-underscore = prefix-underscore;

    root = root;
    log-dir = log-dir;

    celery-signal-logfile = "${log-dir}/${base-paths.default.filenames.celery-signal-log}";
}