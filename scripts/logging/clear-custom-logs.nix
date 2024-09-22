# Contains:
# - Script to clear the custom logs directory
# - Service which runs the script
# - Timer to run the script daily at 00:00
# -- Timer is persistent
# - Polkit rule to allow service user to run the script

{ config, lib, pkgs, agl-network-config, ... }:

let
    conf = agl-network-config.custom-logs;
    service-user = conf.owner;
    service-group = conf.group;
    custom-log-dir = conf.dir;

    clear-custom-log-directory-script-name = "${conf.clear-logs-script-name}";

    dirClearScript = pkgs.writeShellScriptBin "${clear-custom-log-directory-script-name}" ''
        # Clear the custom log directory
        rm -rf "${custom-log-dir}"/*
    '';


in
{
    # Import Polkit Rule to allow agl-admin to run the script
    imports = [
        ( import ../../polkit/openvpn/base-allow-clear.nix {
            agl-network-config = agl-network-config;
            script-path = dirClearScript;
        })
    ];

    # Define the new service that sets up the log directory
    systemd.services."${clear-custom-log-directory-script-name}" = {
        description = "Ensure the custom log directory is available and has correct ownership and permissions";
        serviceConfig = {
            ExecStart = "${dirClearScript}/bin/${clear-custom-log-directory-script-name}";
            User = "root";  # Run as root to ensure directory creation and permissions are correct
            Group = "root";
            # Type = "oneshot";  # Runs once at boot
        };
        wantedBy = [ "multi-user.target" ];  # Ensure this runs during boot
    };

    # Ensure the scripts are available in system packages
    environment.systemPackages = with pkgs; [
        dirClearScript
    ];
}


