let
    prefix = "endoreg-frame-predictor";
    prefix-underscore = "endoreg_frame_predictor";
    deploy-mode = "prod";

    paths = import ../paths.nix;

    multi-ai-version = "0.1.0";
    model-path = "${paths.endoreg-client-manager.root}/models/multi-ai-${multi-ai-version}.ckpt";
    
in {
    model-path = model-path;
    model-version = multi-ai-version;
    video-prediction-smoothing-window = 1; # in seconds
    video-prediction-min-duration = 1; # in seconds
    prediction-dir-parent = ecm-multi-ai-pred-dir;
}