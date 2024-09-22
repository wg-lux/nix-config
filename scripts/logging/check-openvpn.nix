{ config, lib, pkgs, agl-network-config, ... }:

let
    openvpn-conf = agl-network-config.services.openvpn;
    custom-logs-conf = agl-network-config.custom-logs;

    service-user = custom-logs-conf.owner;
    service-group = custom-logs-conf.group;
    custom-log-path = custom-logs-conf.openvpn-log;
    error-log-path = custom-logs-conf.openvpn-error-log;

    vpn-host-ip = custom-logs-conf.ping-vpn-ip;
    www-ip = custom-logs-conf.ping-www-ip;

    #TODO
    # Read script text as variable and import by reading txt.file

    scriptPath = pkgs.writeShellScriptBin "log-openvpn" ''#!/usr/bin/env bash
        # Default path to log file
        LOGFILE=${custom-log-path}

        # Default path to error log file
        ERROR_LOGFILE="${error-log-path}"

        # Create log file if it doesn't exist and add a header if empty
        if [ ! -f "$LOGFILE" ]; then
            echo "Date,Service_Status,Ping_VPN,Ping_WWW" > "$LOGFILE"
        fi

        # Create error log file if it doesn't exist
        if [ ! -f "$ERROR_LOGFILE" ]; then
            touch "$ERROR_LOGFILE"
        fi

        # Function to check service status
        check_service_status() {
            systemctl is-active openvpn-aglNet > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "active"
            else
                echo "inactive"
            fi
        }

        # Function to check ping
        check_ping() {
            local ip=$1
            ping -c 1 $ip > /dev/null 2>>"$ERROR_LOGFILE"
            if [ $? -eq 0 ]; then
                echo "success"
            else
                echo "failure"
            fi
        }

        # Capture the current date and time
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

        # Check the status of the service and ping results
        SERVICE_STATUS=$(check_service_status 2>>"$ERROR_LOGFILE")
        PING_VPN=$(check_ping ${vpn-host-ip})
        PING_WWW=$(check_ping ${www-ip})

        # Append results to the log file
        echo "$TIMESTAMP,$SERVICE_STATUS,$PING_VPN,$PING_WWW" >> "$LOGFILE"

        # Log completion or errors to systemd journal
        if [ "$SERVICE_STATUS" = "inactive" ]; then
            echo "OpenVPN service is inactive." | systemd-cat -t openvpn-aglNet-custom-logger
        fi

        if [ "$PING_VPN" = "failure" ] || [ "$PING_WWW" = "failure" ]; then
            echo "Ping failed to either ${vpn-host-ip} or ${www-ip}." | systemd-cat -t openvpn-aglNet-custom-logger
        fi
  '';

in
{
    # Define the systemd service
    systemd.services.openvpn-aglNet-custom-logger = {
        description = "Writes custom log for OpenVPN service to CSV file at ${custom-log-path} and error log at ${error-log-path}";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            ExecStart = "${scriptPath}/bin/log-openvpn";
            User = service-user;
            Group = service-group;
            AmbientCapabilities = "CAP_NET_RAW"; # Allow to use ping
        };
        path = [ 
            pkgs.sudo 
            pkgs.cryptsetup 
            pkgs.utillinux 
            pkgs.coreutils 
            pkgs.iputils 
            pkgs.systemd 
        ];
    };

    # Define the timer to run the logger service every hour
    systemd.timers.openvpn-aglNet-custom-logger = {
        wantedBy = [ "timers.target" ];
        description = "Timer for custom OpenVPN logger service";
        timerConfig = {
            OnCalendar = "hourly";  # Runs every hour
            Persistent = true; #TODO cahnge to false
        };
        unitConfig = {}; # maybe add some config? Timer is seems to be linked automatically if names match
    };
    
    # Ensure the script is available in system packages
    environment.systemPackages = with pkgs; [
        scriptPath
    ];

}
