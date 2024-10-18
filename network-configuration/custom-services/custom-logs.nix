let
    paths = import ../paths.nix;
    users = import ../users.nix;
    groups = import ../groups.nix;
    ips = import ../ips.nix;
    scripts = import ./scripts.nix;

    ping-www = "8.8.8.8";
    ping-vpn = ips.openvpn-host-ip;

    clear-custom-logs-script-name = scripts.clear-custom-logs-script-name;
    openvpn-custom-log-script-name = scripts.openvpn-custom-log-script-name;
    timer-on-calendar-15-min = "*:0/15"; # Every 15 minutes

in {
    owner = users.service;
    group = groups.service;
    dir = paths.custom-logs-dir;

    clear-logs-script-name = scripts.clear-custom-logs-script-name;
    openvpn-custom-log-script-name = scripts.openvpn-custom-log-script-name;
    
    timers = {
        openvpn-logger = timer-on-calendar-15-min;
    };
    
    ping-vpn = ping-vpn
    ping-www = ping-www;
}