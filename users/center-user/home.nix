{ config, pkgs, lib, ... }:

{

  imports = [
    ../shared/xdg.nix
    ( import ../shared/ui.nix {inherit pkgs;})
    ( import ./packages.nix {inherit pkgs;})
    ../shared/autoSuspendAndLogin.nix
    ./files/base.nix

    # Files
    # ( import ./files/base.nix { inherit config lib pkgs; })
  ];

  home.username = "center-user";
  home.homeDirectory = "/home/center-user";
  home.stateVersion = "23.11";

  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

}
