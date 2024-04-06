{ config, pkgs, ... }: {
  imports = [];
  # SOPS
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = /home/agl-admin/.config/sops/age/keys.txt;
}