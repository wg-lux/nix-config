{ config, pkgs, ... }:

let 
    # hostname = config.networking.hostName;
    # wireless-secret-path = ../../secrets + ("/${hostname}/wireless.env");
in
{
  
  # sops.secrets.wireless-env = {
  #   sopsFile = wireless-secret-path;
  #   path = "/etc/wireless/wireless.env";
  #   # Specify the type of the secret
  #   format = "dotenv";
  # };

  # networking.networkmanager.enable = pkgs.lib.mkForce false;
  networking.networkmanager.enable = true;
  # networking.wireless = {
  #   enable = true;
  #   # enable = false;
  #   environmentFile = config.sops.secrets.wireless-env.path; # Reference to your environment file
  #   networks = {
  #     "FreundeDerIndischenBrotsuppe" = {
  #       priority = 1;
  #       pskRaw = "@PSK_HOME@"; # Referencing the home network PSK from the environment file
  #     };
  #     "agl-p" = {
  #       priority = 2;
  #       psk = "@PSK_MOBILE@"; # Referencing the work network PSK from the environment file
  #     };
  #     "Krambambuli 100" = {
  #       priority = 3;
  #       pskRaw = "@PSK_RICHTER@"; # Referencing the work network PSK from the environment file
  #       # hidden = true;
  #       # auth = ''
  #       #   key_mgmt=WPA-EAP
  #       #   eap=PEAP
  #       #   phase2="auth=MSCHAPV2"
  #       #   identity="unx42"
  #       #   password="@PASS_UWF@" # Referencing the UWF network password from the environment file
  #       # '';
  #     };
  #   };
  # };
}


