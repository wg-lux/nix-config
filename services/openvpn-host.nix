{
  pkgs, config, lib, 
  openvpn-config,
  ...
}: 
let
  sopsfiles = import ../../sopsfiles.nix {inherit config;};
  openvpn-sopsfile = sopsfiles.openvpn-host; # TODO NOT USED?
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

  secret-path-openvpn-shared = ../secrets/shared/openvpn.yaml;

in
lib.mkIf (config.networking.hostName == openvpn-host-hostname) {
  environment.systemPackages = [
    pkgs.openvpn
    pkgs.vault
  ];

  # Allow firewall tcp 1194
  networking.firewall.allowedTCPPorts = openvpn-host-tcp;

  services.openvpn.restartAfterSleep = true;
  services.openvpn.servers = {
    aglNetHost = { 
      config = '' config ${openvpn-config-path}/${openvpn-config-file}'';
      autoStart = true;
      updateResolvConf = true;
    };
  };

  sops.secrets."shared/openvpn-aglNet/server-ta-key" = {
      sopsFile = secret-path-openvpn-shared;
      path = "${openvpn-cert-path}/ta.key";
      owner = openvpn-user;
      mode = openvpn-file-mode;
      group = openvpn-group;
  };

  sops.secrets."shared/openvpn-aglNet/ca-cert" = {
      sopsFile = secret-path-openvpn-shared;
      path = "${openvpn-cert-path}/ca.crt";
      owner = openvpn-user;
      mode = openvpn-file-mode;
      group = openvpn-group;
  };
}

