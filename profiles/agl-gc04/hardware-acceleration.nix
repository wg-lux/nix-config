{pkgs, ...} : {

    environment.systemPackages = with pkgs; [
        # lm_sensors
        # powertop
        # thermald
        # tlp
        # rtkit
    ];

    hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
            # intel-media-driver # LIBVA_DRIVER_NAME=iHD
            # intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
            # vaapiVdpau
            # libvdpau-va-gl
        ];
    };
    # environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver


    # programs.powerManagement.enable = false;
}