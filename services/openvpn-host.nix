{
  pkgs, config, lib, 
  openvpn-config,
  ...
}: 
let
  hostname = config.networking.hostName;
  
  openvpn-user = openvpn-config.user;
  openvpn-group = openvpn-config.group;
  openvpn-file-mode = openvpn-config.file-mode;

  openvpn-config-path = openvpn-config.config-path;
  openvpn-cert-path = openvpn-config.cert-path;
  openvpn-config-file = openvpn-config.host-config-file;

  network-interface = openvpn-config.network-interface;

  openvpn-host-hostname = openvpn-config.host-hostname;
  openvpn-host-tcp = openvpn-config.host-tcp-ports;

  # secret-path-openvpn-shared = ../secrets/shared/openvpn.yaml;
  secret-path-openvpn = ../secrets + ("/" + "${hostname}/services/openvpn-aglNet.yaml");

in
lib.mkIf (config.networking.hostName == openvpn-host-hostname) {
  environment.systemPackages = [
    pkgs.openvpn
  ];

  # Allow firewall tcp 1194
  networking.firewall.allowedTCPPorts = openvpn-host-tcp;

  services.openvpn.servers = {
    aglNetHost = { 
      config = '' config ${openvpn-config-path}/${openvpn-config-file}'';
      autoStart = true;
      updateResolvConf = true;
    };
  };

  sops.secrets."services/openvpn-aglNet/dh-pem" = {
    sopsFile = secret-path-openvpn;
    path = "${openvpn-cert-path}/dh.pem";
    format = "yaml";
    owner = "agl-admin";
  };

  sops.secrets."services/openvpn-aglNet/server-cert" = {
    sopsFile = secret-path-openvpn;
    path = "${openvpn-cert-path}/server.crt";
    format = "yaml";
    owner = "agl-admin";
  };

  sops.secrets."services/openvpn-aglNet/server-key" = {
    sopsFile = secret-path-openvpn;
    path = "${openvpn-cert-path}/server.key";
    format = "yaml";
    owner = "agl-admin";
  };
}

