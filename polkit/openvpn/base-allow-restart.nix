{
    agl-network-config, ...
}:
let

    openvpn-conf = agl-network-config.services.openvpn;

    openvpn-service-name = openvpn-conf.service-name;
    service-group = openvpn-conf.group;
    admin-user = agl-network-config.users.admin-user;
    center-user = agl-network-config.users.center-user;

in
{
    security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
            if (
                action.id == "org.freedesktop.systemd1.manage-units" &&
                action.lookup("unit") == "${openvpn-service-name}.service" &&
                (
                    subject.isInGroup("${service-group}" ||
                    subject.isInGroup("wheel") ||
                    subject.name == "${admin-user}") ||
                    subject.name == "${center-user}"
                ) &&
                (
                    action.lookup("verb") == "start" || 
                    action.lookup("verb") == "stop") ||
                    action.lookup("verb") == "restart"
                ) {
                    return polkit.Result.YES;
                }
        });
    '';
}