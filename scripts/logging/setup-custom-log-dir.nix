{ config, lib, pkgs, agl-network-config, ... }:

let
    conf = agl-network-config.custom-logs;
    service-user = conf.owner;
    service-group = conf.group;
    custom-log-dir = conf.dir;

    dirSetupScript = pkgs.writeShellScriptBin "setup-custom-log-directory" ''
        # Ensure the log directory exists
        if [ ! -d "${custom-log-dir}" ]; then
            mkdir -p "${custom-log-dir}"
        fi

        # Ensure the correct owner, group, and permissions
        chown ${service-user}:${service-group} "${custom-log-dir}"
        chmod 0775 "${custom-log-dir}"
    '';


in
{
   # Define the new service that sets up the log directory
    systemd.services.custom-log-directory-setup = {
        description = "Ensure the custom log directory is available and has correct ownership and permissions";
        serviceConfig = {
            ExecStart = "${dirSetupScript}/bin/setup-custom-log-directory";
            User = "root";  # Run as root to ensure directory creation and permissions are correct
            Group = "root";
            Type = "oneshot";  # Runs once at boot
        };
        wantedBy = [ "multi-user.target" ];  # Ensure this runs during boot
        before = [ "openvpn-aglNet-custom-logger.service" ];  # Ensure it runs before the logger service
    };

    # Ensure the scripts are available in system packages
    environment.systemPackages = with pkgs; [
        dirSetupScript
    ];
}
