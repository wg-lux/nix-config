{config, pkgs, agl-network-config, ...}: 

let
  identity-file-paths = agl-network-config.identity-file-paths;

  ssh-id-ed25519-file-path = identity-file-paths.ssh-id-ed25519;
  ssh-id-ed25519-user-file-path = identity-file-paths.ssh-id-ed25519-user;
  
  age-keys-file-path = identity-file-paths.age-key-file-path;
  age-keys-user-file-path = identity-file-paths.age-key-file-user-file-path;

in
{

  imports = [
    ../../shared/files.nix
  ];

  home.file."/.ssh" = {
    source = ./.ssh;
    target = "/.ssh"; # default is name defined in home.file.NAME#FIXME
    recursive = true;
  };

  # home.file."${ssh-id-ed25519-user-file-path}" = {
  #   # source = ssh-id-ed25519-file-path;
  #   source = "/etc/id_ed25519";
  # };

  home.file."/tmux-templates" = {
    source =./tmux/tmux-templates;
    recursive = true;
  };
  

  home.file."/.zshrc" = {
    source =./.zshrc;
  };

  home.file."/.config" = {
    source = ./.config;
    recursive = true;
  };

  # home.file."${age-keys-user-file-path}" = {
  #   source = age-keys-file-path;
  # };


}