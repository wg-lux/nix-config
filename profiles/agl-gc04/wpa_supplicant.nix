{ config, pkgs, ... }:

let 
    hostname = config.networking.hostName;
    wireless-secret-path = ../../secrets + ("/${hostname}/wireless.env");
in
{
  
  sops.secrets.wireless-env = {
    sopsFile = wireless-secret-path;
    path = "/etc/wireless/wireless.env";
    # Specify the type of the secret
    format = "dotenv";
  };

  # networking.networkmanager.enable = pkgs.lib.mkForce false;
  networking.wireless = {
    # enable = true;
    enable = false;
    environmentFile = config.sops.secrets.wireless-env.path; # Reference to your environment file
    networks = {
    };
  };
}


