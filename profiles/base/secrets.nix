{ hostname, openvpnCertPath, ... }:

let

secret-path-users = ../../secrets + ("/" + "${hostname}/user.yaml");
secret-path-id_ed25519 = ../../secrets + ("/" + "${hostname}/id_ed25519.yaml");
secret-path-openvpn-shared = ../../secrets/shared/openvpn.yaml;
secret-path-openvpn = ../../secrets + ("/" + "${hostname}/openvpn.yaml");

in
{

    sops.secrets."identity/id_ed25519" = {
        sopsFile = secret-path-id_ed25519;
        path = "/home/agl-admin/.ssh/id_ed25519";
        format = "yaml";
        owner = "agl-admin";
    };

    sops.secrets."user/nix/root/pwd" = {
        sopsFile = secret-path-users;
        neededForUsers=true;
        mode = "700";
    };

    sops.secrets."user/nix/agl-admin/pwd" = {
        sopsFile = secret-path-users;
        neededForUsers=true;
        mode = "700";
    };

    sops.secrets."user/nix/default-user/pwd" = {
      sopsFile = secret-path-users;
      neededForUsers = true;
      mode = "700";
    };

    sops.secrets."user/nix/center-user/pwd" = {
      sopsFile = secret-path-users;
      neededForUsers = true;
      mode = "700";
    };#

    sops.secrets."user/nix/maintenance-user/pwd" = {
      sopsFile = secret-path-users;
      neededForUsers = true;
      mode = "700";
    };

    sops.secrets."user/nix/service-user/pwd" = {
      sopsFile = secret-path-users;
      neededForUsers = true;
      mode = "700";
    };

    sops.secrets."services/openvpn/aglNet-client/cert" = {
        sopsFile = secret-path-openvpn;
        path = "${openvpnCertPath}/cert.crt";
        owner = "agl-admin";
    };
    sops.secrets."services/openvpn/aglNet-client/key" = {
        sopsFile = secret-path-openvpn;
        path = "${openvpnCertPath}/key.key";
        format = "yaml";
        owner = "agl-admin";
    };


    sops.secrets."shared/openvpn-aglNet/server-ta-key" = {
        sopsFile = secret-path-openvpn-shared ;
        path = "${openvpnCertPath}/ta.key";
        owner = "agl-admin";
    };
    
    sops.secrets."shared/openvpn-aglNet/ca-cert" = {
        sopsFile = secret-path-openvpn-shared;
        path = "${openvpnCertPath}/ca.crt";
        owner = "agl-admin";
    };
    
}