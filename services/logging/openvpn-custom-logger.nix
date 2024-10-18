{ config, lib, pkgs, agl-network-config, ... }@inputs:

let
    hostname = config.networking.hostName;

    openvpn-config = agl-network-config.services.openvpn;
    paths = openvpn-config.paths;

    logger-config = openvpn-config.logger-config;
    service-user = logger-config.user;
    service-group = logger-config.group;
    log-script-name = logger-config.log-script-name;
    clear-log-script-name = logger-config.clear-log-script-name;
    timer-on-calendar = logger-config.timer;

    ips = agl-network-config.ips;
    aglnet-ip = inputs.ips.by-hostname."${hostname}";

    custom-log-path = paths.log-filepath;
    error-log-path = paths.errorlog-filepath;

    vpn-host-ip = logger-config.ping-vpn;
    www-ip = logger-config.ping-www;

    openvpn-service-name = openvpn-config.service-name;

    admin-user = agl-network-config.users.admin-user;
    center-user = agl-network-config.users.center-user;


    scriptPath = pkgs.writeShellScriptBin "${log-script-name}" ''#!/usr/bin/env bash
        # Default path to log file
        LOGFILE=${custom-log-path}

        # Default path to error log file
        ERROR_LOGFILE="${error-log-path}"

        # Default VPN service name
        VPN_SERVICE="${openvpn-service-name}"

        # Create log file if it doesn't exist and add a header if empty
        if [ ! -f "$LOGFILE" ]; then
            echo "datetime,device,aglnet_ip,vpn_service_status,vpn_service_restart_attempt,vpn_service_restart_success,ping_vpn,ping_www" > "$LOGFILE"

            # Ensure the correct owner, group, and permissions
            chown ${service-user}:${service-group} "$LOGFILE"
            chmod 775 "$LOGFILE"

        fi

        # Create error log file if it doesn't exist
        if [ ! -f "$ERROR_LOGFILE" ]; then
            touch "$ERROR_LOGFILE"

            # Ensure the correct owner, group, and permissions
            chown ${service-user}:${service-group} "$ERROR_LOGFILE"
        fi

        # Function to check service status
        check_service_status() {
            systemctl is-active "$VPN_SERVICE" > /dev/null 2>&1
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

        # Function to restart VPN service
        restart_vpn_service() {
            systemctl restart "$VPN_SERVICE" > /dev/null 2>>"$ERROR_LOGFILE"
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

        # Initialize variables for VPN restart
        TRIGGERED_VPN_RESTART="False"
        VPN_RESTART_SUCCESS="n/a"

        # Check if ping to VPN failed and attempt to restart if needed
        if [ "$PING_VPN" = "failure" ]; then
            TRIGGERED_VPN_RESTART="True"
            VPN_RESTART_SUCCESS=$(restart_vpn_service)
            
            if [ "$VPN_RESTART_SUCCESS" = "failure" ]; then
                echo "[$TIMESTAMP] Failed to restart $VPN_SERVICE." >> "$ERROR_LOGFILE"
                echo "[$TIMESTAMP] Restart of $VPN_SERVICE failed." | systemd-cat -t openvpn-aglNet-custom-logger
            else
                echo "[$TIMESTAMP] Successfully restarted $VPN_SERVICE." | systemd-cat -t openvpn-aglNet-custom-logger
            fi
        fi

        # Append results to the log file
        echo "$TIMESTAMP,${hostname},${aglnet-ip},$SERVICE_STATUS,$TRIGGERED_VPN_RESTART,$VPN_RESTART_SUCCESS,$PING_VPN,$PING_WWW" >> "$LOGFILE"

        # Log completion or errors to systemd journal
        if [ "$SERVICE_STATUS" = "inactive" ]; then
            echo "OpenVPN service is inactive." | systemd-cat -t openvpn-aglNet-custom-logger
        fi

        if [ "$PING_VPN" = "failure" ] || [ "$PING_WWW" = "failure" ]; then
            echo "Ping failed to either ${vpn-host-ip} or ${www-ip}." | systemd-cat -t openvpn-aglNet-custom-logger
        fi
  '';

in {
    # Import Polkit Rules
    imports = [
        ( import ../../polkit/openvpn/base-allow-restart.nix {
            inherit agl-network-config;
        })
        ( import ../../polkit/openvpn/base-allow-logging.nix {
            inherit agl-network-config;
            log-script-path = scriptPath;
        })
    ];

    # Define the systemd service
    systemd.services.openvpn-aglNet-custom-logger = {
        description = "Writes custom log for OpenVPN service to CSV file at ${custom-log-path} and error log at ${error-log-path}";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            ExecStart = "${scriptPath}/bin/${log-script-name}";
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
            # https://silentlad.com/systemd-timers-oncalendar-(cron)-format-explained
            OnCalendar = timer-on-calendar;  # Runs every hour 
            Persistent = true; #TODO cahnge to false
        };
        unitConfig = {}; # maybe add some config? Timer is seems to be linked automatically if names match
    };

    # Ensure the script is available in system packages
    environment.systemPackages = with pkgs; [
        scriptPath
    ];
}
