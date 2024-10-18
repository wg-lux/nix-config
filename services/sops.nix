{ config, pkgs, agl-network-config, ... }: 


let

  sopsfiles = import ../sopsfiles.nix;

  hostname = config.networking.hostName;

  sops-config = agl-network-config.services.sops;
  paths = sops-config.paths;
  
  sops-default-format = sops-config.default-format;
  etc-keyfile-sops-target = paths.sops-targets.etc-age-key-file;
  age-key-file-etc-path = paths.file.targets.age-key-file;
  etc-age-keyfile-sopsfile = sopsfiles.etc-age-keyfile-sopsfile;
  
  
in
{
  imports = [];

  # SOPS
  sops.defaultSopsFormat = sops-default-format;
  sops.age.keyFile = sops-config.default-key-file; # Points to pre-provided (at deployment) key file
  sops.age.generateKey = false; # If true and no key file is present, will generate a new key file


  # provide basic system-id-file age key file using sops
  sops.secrets."${etc-keyfile-sops-target}" = {
    sopsFile = etc-age-keyfile-sopsfile;
    path = age-key-file-etc-path;
    format = "binary";
    neededForUsers = true;
  };


}