let 
    base-paths = import ./base.nix;
    custom-logs-dir = base-paths.default.paths.custom-logs-dir;

    prefix = "endoreg-home";
    root = "/etc/${prefix}";
    tmp-root = "${sensitive-data-temporary}/${prefix}";
    log-dir = "${custom-logs-dir}/${prefix}";

in {

    root = root;
    tmp-root = tmp-root;

    log = {
        root = log-dir;
        filename = "endoreg-home-log.csv";
        error-filename = "endoreg-home-error.log";    
        django-logfile = "${log-dir}/${base-paths.default.filenames.django-log}";
        celery-logfile = "${log-dir}/${base-paths.default.filenames.celery-log}";
    };
}