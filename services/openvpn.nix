{pkgs, config, lib, ...}: 

lib.mkIf (config.networking.hostName != "agl-server-01") {

  environment.systemPackages = [
    pkgs.openvpn
  ];

  # depends on working wireless connection on device wlo1
  # networking.networkmanager.wireless.enable = true;

  services.openvpn.servers = {
    aglNet = { 
      config = '' config /home/agl-admin/.openvpn/aglNet.conf '';
      autoStart = true;
      updateResolvConf = true;
    };
  };

}

