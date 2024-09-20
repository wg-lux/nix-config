{pkgs, config, lib, openvpn-config-path, openvpn-cert-path,...}: 
let
  hostname = config.networking.hostName;
  secretPath = ../secrets + ("/" + "${hostname}/services/openvpn-aglNet.yaml");

in
lib.mkIf (config.networking.hostName == "agl-server-01") {
  environment.systemPackages = [
    pkgs.openvpn
  ];

  # Allow firewall tcp 1194
  networking.firewall.allowedTCPPorts = [ 1194 ];

  services.openvpn.servers = {
    aglNetHost = { 
      config = '' config ${openvpn-config-path}/aglNetHost.conf '';
      autoStart = true;
      updateResolvConf = true;
    };
  };

  sops.secrets."services/openvpn-aglNet/dh-pem" = {
    sopsFile = secretPath;
    path = "${openvpn-cert-path}/dh.pem";
    format = "yaml";
    owner = "agl-admin";
  };

  sops.secrets."services/openvpn-aglNet/server-cert" = {
    sopsFile = secretPath;
    path = "${openvpn-cert-path}/server.crt";
    format = "yaml";
    owner = "agl-admin";
  };

  sops.secrets."services/openvpn-aglNet/server-key" = {
    sopsFile = secretPath;
    path = "${openvpn-cert-path}/server.key";
    format = "yaml";
    owner = "agl-admin";
  };
}

