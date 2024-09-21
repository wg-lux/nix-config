{config, pkgs, lib, ...}: {

  imports = [
    ../../shared/files.nix
  ];

  home.file."/.ssh" = {
    source = ./.ssh;
    target = "/.ssh"; # default is name defined in home.file.NAME#FIXME
    recursive = true;
  };

  home.file."/tmux-templates" = {
    source =./tmux/tmux-templates;
  };

  home.file."/.zshrc" = {
    source =./.zshrc;
  };

  home.file."/.config" = {
    source = ./.config;
    target = "/.config"; # default is name defined in home.file.NAME
    recursive = true;
  };
}