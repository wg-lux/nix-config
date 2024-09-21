{

    openvpn-config,
    ...
}:

let

    etc-config-data-dir = ../../../config/etc;
    
    openvpn-config-source-dir = etc-config-data-dir + "/openvpn";
    openvpn-cert-source-dir = etc-config-data-dir + "/openvpn-cert";
    openvpn-target-dir = openvpn-config.config-path;

    client-config-file-name = openvpn-config.client-config-file;
    client-config-file-source-path = openvpn-config-source-dir + ("/" + client-config-file-name);

    cert-config-init-file-name = "init";
    cert-config-init-file-source-path = openvpn-cert-source-dir + ("/" + cert-config-init-file-name);

    host-config-file-name = openvpn-config.host-config-file;
    host-config-file-source-path = openvpn-config-source-dir + ("/" + host-config-file-name);
    
    update-resolv-conf-file-name = "update-resolv-conf";
    update-resolv-conf-source-path = openvpn-config-source-dir + ("/" + update-resolv-conf-file-name);

    ccd-dir = etc-config-data-dir + "/openvpn/ccd";

in
{
    environment.etc."openvpn/${client-config-file-name}" = {
        source = client-config-file-source-path;
        user = openvpn-config.user;
        group = openvpn-config.group;
        mode = "0755";
    };

    environment.etc."openvpn/${host-config-file-name}" = {
        source = host-config-file-source-path;
        user = openvpn-config.user;
        group = openvpn-config.group;
        mode = "0755";
    };

    environment.etc."openvpn/${update-resolv-conf-file-name}" = {
        source = update-resolv-conf-source-path;
        user = openvpn-config.user;
        group = openvpn-config.group;
        mode = "0755";
    };

    # copy the ccd directory
    environment.etc."openvpn/ccd" = {
        source = ccd-dir;
        user = openvpn-config.user;
        group = openvpn-config.group;
        mode = "symlink";
    };

    # copy the cert directory
    environment.etc."openvpn-cert/init" = {
        source = cert-config-init-file-source-path;
        user = openvpn-config.user;
        group = openvpn-config.group;
        mode = "0755";
    };
}