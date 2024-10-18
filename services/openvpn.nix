{
  pkgs, config, lib, 
  openvpn-config, 
  
  ...}: 

let
  sopsfiles = import ../../sopsfiles.nix {inherit config;};
  openvpn-sopsfile = sopsfiles.openvpn;

  hostname = config.networking.hostName;

  openvpn-user = openvpn-config.user;
  openvpn-group = openvpn-config.group;
  file-mode = openvpn-config.file-mode;
  network-interface = openvpn-config.network-interface;
  openvpn-host-hostname = openvpn-config.host-hostname;

  openvpn-config-path = openvpn-config.config-path;
  openvpn-cert-path = openvpn-config.cert-path;
  openvpn-config-file = openvpn-config.client-config-file;

in

lib.mkIf (config.networking.hostName != openvpn-host-hostname) {


  imports = [
        (
        import ./logging/openvpn-aglNet-custom-logger.nix {
            inherit config pkgs lib agl-network-config;
        }
    )
  ];

  environment.systemPackages = [
    pkgs.openvpn
  ];


  services.openvpn.restartAfterSleep = true;
  services.openvpn.servers = {
    aglNet = { 
      config = '' config ${openvpn-config-path}/${openvpn-config-file} '';
      autoStart = true;
      updateResolvConf = true;
    };
  };

  # Secrets 
  sops.secrets."services/openvpn/aglNet-client/cert" = {
        sopsFile = openvpn-sopsfile;
        path = "${openvpn-cert-path}/cert.crt";
        owner = openvpn-user;
        mode = file-mode;
        group = openvpn-group;
    };

  sops.secrets."services/openvpn/aglNet-client/key" = {
      sopsFile = openvpn-sopsfile;
      path = "${openvpn-cert-path}/key.key";
      format = "yaml";
      owner = openvpn-user;
      mode = file-mode;
      group = openvpn-group;
  };



}

