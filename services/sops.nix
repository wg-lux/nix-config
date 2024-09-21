{ config, pkgs, agl-network-config, ... }: 


let
  hostname = config.networking.hostName;
  sops-config = agl-network-config.services.sops;

  sops-default-format = sops-config.default-format;
  sops-default-key-file = sops-config.default-key-file;
  
  age-key-file-etc-path = agl-network-config.identity-file-paths.age-key-file;
  secrets-age-keyfile-path = ../secrets + ("/" + "${hostname}/age-keys.txt");

  sops-user = sops-config.user;
  
in
{
  imports = [];

  # automatically uses .sops.yaml in configuration root as configuration file

  # provide age key file using sops
  sops.secrets."age-keys-txt" = {
    sopsFile = secrets-age-keyfile-path;
    path = age-key-file-etc-path;
    format = "binary";
    # owner = sops-user;
    neededForUsers = true;
  };

  # SOPS
  # sops.defaultSopsFile = sops-default-sops-file;
  sops.defaultSopsFormat = sops-default-format;
  sops.age.keyFile = sops-config.default-key-file;
  
  # sops.age.keyFile = /home/agl-admin/.config/sops/age/keys.txt;
  sops.age.generateKey = false;
}