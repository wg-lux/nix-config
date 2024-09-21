{
  pkgs, config, lib, 
  openvpn-config, 
  
  ...}: 

let
  hostname = config.networking.hostName;

  openvpn-user = openvpn-config.user;
  openvpn-group = openvpn-config.group;
  file-mode = openvpn-config.file-mode;

  openvpn-config-path = openvpn-config.config-path;
  openvpn-cert-path = openvpn-config.cert-path;
  openvpn-config-file = openvpn-config.client-config-file;

  network-interface = openvpn-config.network-interface;

  openvpn-host-hostname = openvpn-config.host-hostname;

  secret-path-openvpn-shared = ../secrets/shared/openvpn.yaml;
  secret-path-openvpn = ../secrets + ("/" + "${hostname}/openvpn.yaml");

in

lib.mkIf (config.networking.hostName != openvpn-host-hostname) {

  environment.systemPackages = [
    pkgs.openvpn
  ];

  services.openvpn.servers = {
    aglNet = { 
      config = '' config ${openvpn-config-path}/${openvpn-config-file} '';
      autoStart = true;
      updateResolvConf = true;
    };
  };

  sops.secrets."services/openvpn/aglNet-client/cert" = {
        sopsFile = secret-path-openvpn;
        path = "${openvpn-cert-path}/cert.crt";
        owner = openvpn-user;
        mode = file-mode;
        group = openvpn-group;
    };
    sops.secrets."services/openvpn/aglNet-client/key" = {
        sopsFile = secret-path-openvpn;
        path = "${openvpn-cert-path}/key.key";
        format = "yaml";
        owner = openvpn-user;
        mode = file-mode;
        group = openvpn-group;
    };

    sops.secrets."shared/openvpn-aglNet/server-ta-key" = {
        sopsFile = secret-path-openvpn-shared;
        path = "${openvpn-cert-path}/ta.key";
        owner = openvpn-user;
        mode = file-mode;
        group = openvpn-group;
    };
    
    sops.secrets."shared/openvpn-aglNet/ca-cert" = {
        sopsFile = secret-path-openvpn-shared;
        path = "${openvpn-cert-path}/ca.crt";
        owner = openvpn-user;
        mode = file-mode;
        group = openvpn-group;
    };

}

