{
    agl-network-config, 
    script-path,
    ...
}:
let
    logging-conf = agl-network-config.custom-logs;
    admin-user = agl-network-config.users.admin-user;
    script-name = logging-conf.openvpn-custom-log-script-name;

in
{
    security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
            if (
                action.id == "org.freedesktop.policykit.exec" &&
                action.lookup("program") == "${script-path}/bin/${script-name}" &&
                subject.name == "${admin-user}"
            ) {
                return polkit.Result.YES;
            }
        });
    '';
}