{
    agl-network-config,
    script-path,
    ...
}@inputs:
let
    openvpn-config = agl-network-config.services.openvpn;
    admin-user = agl-network-config.users.admin-user;
    logger-user = openvpn-config.logger-config.user;
    script-name = openvpn-config.logger-config.clear-log-script-name;

in
{
    security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
            if (
                action.id == "org.freedesktop.policykit.exec" &&
                action.lookup("program") == "${script-path}/bin/${clear-log-script-name}" &&
                subject.name == "${admin-user}"
            ) {
                return polkit.Result.YES;
            }
        });
        polkit.addRule(function(action, subject) {
            if (
                action.id == "org.freedesktop.policykit.exec" &&
                action.lookup("program") == "${script-path}/bin/${script-name}" &&
                subject.name == "${logger-user}"
            ) {
                return polkit.Result.YES;
            }
        });
    '';
}