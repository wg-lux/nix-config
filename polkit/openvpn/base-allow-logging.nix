{
    agl-network-config, 
    log-script-path,
    ...
}:
let

    openvpn-conf = agl-network-config.services.openvpn;
    logging-conf = agl-network-config.custom-logs;

    openvpn-service-name = openvpn-conf.service-name;
    service-group = openvpn-conf.group;
    admin-user = agl-network-config.users.admin-user;
    center-user = agl-network-config.users.center-user;
    custom-log-script-name = logging-conf.openvpn-custom-log-script-name;

in
{
    security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
            if (
                action.id == "org.freedesktop.policykit.exec" &&
                action.lookup("program") == "${log-script-path}/bin/${custom-log-script-name}" &&
                subject.name == "${admin-user}"
            ) {
                return polkit.Result.YES;
            }
        });
    '';
}