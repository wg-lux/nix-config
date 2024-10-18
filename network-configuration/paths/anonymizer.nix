let 
    base-paths = import ./base.nix;

    prefix = "agl-anonymizer";
    prefix-underscore = "agl_anonymizer";

    root = "/etc/${prefix}";
    log-root = "${base-paths.default.paths.custom-logs-dir}/${prefix}";
    tmp-root = "${base-paths.default.paths.sensitive-data-temporary}/${prefix}";

in {
    prefix = prefix;
    prefix-underscore = prefix-underscore;

    root = root;
    log-root = log-root;
    tmp-root = tmp-root;
    blurred-dir = "${root}/blurred_results";
    csv-dir = "${root}/csv_training_data";
    results-dir = "${root}/results";
    models-dir = "${root}/models";
    input-dir = "${root}/input";
    tmp-root = anonymizer-tmp-root;
    tmp-dir = "${anonymizer-tmp-root}/tmp";

}