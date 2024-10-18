let 
    base-paths = import ./base.nix;
    custom-logs-dir = base-paths.default.paths.custom-logs-dir;

    prefix = "endoreg-client-manager";
    root = "/etc/${prefix}";
    tmp-root = "${sensitive-data-temporary}/${prefix}";
    log-dir = "${custom-logs-dir}/${prefix}";

in {
    root = root;
    tmp-root = tmp-root;

    
    log-dir = log-dir;

    django-logfile = "${log-dir}/${base-paths.default.filenames.django-log}";
    celery-logfile = "${log-dir}/${base-paths.default.filenames.celery-log}";
}