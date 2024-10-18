let 
    base-paths = import ./base.nix;

    sensitive-data-temporary = base-paths.storage.sensitive-data-temporary;

    prefix = "frame-predictor";
    prefix-underscore = "frame_predictor";

    root = "/etc/${prefix}";
    tmp-root = "${sensitive-data-temporary}/${prefix}";

in {
    prefix = prefix;
    prefix-underscore = prefix-underscore;

    prediction-dir = "${root}/multi-ai-pred";
}