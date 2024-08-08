{pkgs, ...} : {

    environment.systemPackages = with pkgs; [
        # lm_sensors
        # powertop
        # thermald
        # tlp
        # rtkit
    ];


}