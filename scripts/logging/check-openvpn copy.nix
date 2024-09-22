{ config, lib, pkgs, agl-network-config, ... }:

let
    service-user = agl-network-config.service-config.service-user;
    service-group = agl-network-config.service-config.service-group;

    scriptPath = pkgs.writeShellScriptBin "log-openvpn" ''
        # Default path to log file
        LOGFILE=/etc/custom-logs/openvpn-aglNet-log.csv

        # Create log file if it doesn't exist and add a header if empty
        if [ ! -f "$LOGFILE" ]; then
        echo "Date,Service_Status,Ping_172.16.255.1,Ping_8.8.8.8" > "$LOGFILE"
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
        ping -c 1 $ip > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "success"
        else
            echo "failure"
        fi
        }

        # Capture the current date and time
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

        # Check the status of the service and ping results
        SERVICE_STATUS=$(check_service_status)
        PING_172=$(check_ping 172.16.255.1)
        PING_8888=$(check_ping 8.8.8.8)

        # Append results to the log file
        echo "$TIMESTAMP,$SERVICE_STATUS,$PING_172,$PING_8888" >> "$LOGFILE"
  '';

in
{
    systemd.services.openvpn-aglNet-custom-logger = {
        description = "Writes custom log for OpenVPN service to CSV file at /etc/custom-logs/openvpn-aglNet-log.csv";
        serviceConfig = {
            ExecStart = "${scriptPath}/bin/log-openvpn";
            User=service-user;
            Group=service-group;
        };
        path = [ pkgs.sudo pkgs.cryptsetup pkgs.utillinux pkgs.coreutils ];
    };

    environment.systemPackages = with pkgs; [
        scriptPath
  ];

}