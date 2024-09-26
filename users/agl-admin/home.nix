{ config, pkgs, lib, agl-network-config, ... }:

{

  imports = [
    ../shared/xdg.nix

    ./git.nix
    ( import ./desktop.nix {
      inherit config pkgs lib;
    })
    ./tmux.nix
    ( import ./activation.nix {inherit lib;})
    ( import ./packages.nix {inherit pkgs;})
    ../shared/autoSuspendAndLogin.nix
    ../shared/terminal/kitty.nix # Terminal Layout

    # Files
    ( import ./files/base.nix { inherit config lib pkgs agl-network-config; })
  ];

  home.username = "agl-admin";
  home.homeDirectory = "/home/agl-admin";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home = {
    # sessionPath = [ "~/.emacs.d/bin" ];
    sessionVariables = {
      TESTYTEST  = "testytest";
    };
    file = {
    };
  };

  # Configuration located at ~/.config/emacs
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;  # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
    extraConfig = ''
      (setq standard-indent 2)
    '';
  };

  # services.emacs = {
  #   enable = true;
  #   package = pkgs.emacs-gtk;  # replace with pkgs.emacs, or a version provided by the community overlay if desired.
  # };

  # Home Manager
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
