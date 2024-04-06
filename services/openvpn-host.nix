{pkgs, config, lib, openvpnConfigPath,...}: 

lib.mkIf (config.networking.hostName == "agl-server-01") {
  environment.systemPackages = [
    pkgs.openvpn
  ];

  # Allow firewall tcp 1194
  networking.firewall.allowedTCPPorts = [ 1194 ];

  services.openvpn.servers = {
    aglNetHost = { 
      config = '' config ${openvpnConfigPath}/aglNetHost.conf '';
      autoStart = true;
      updateResolvConf = true;
    };
  };
}

