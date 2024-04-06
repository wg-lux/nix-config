{ config, pkgs, lib, ... }:

{

  imports = [
    ../shared/xdg.nix
    ( import ../shared/ui.nix {inherit pkgs;})
    ../shared/bash.nix
    ../shared/autoSuspendAndLogin.nix

    # Files
    # ( import ./files/base.nix { inherit config lib pkgs; })
  ];

  home.username = "maintenance-user";
  home.homeDirectory = "/home/maintenance-user";
  home.stateVersion = "23.11";

  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

}
