{ config, pkgs, ... }: {
  environment.systemPackages = [  # with pkgs; [
    pkgs.direnv
  ];

  programs.bash.interactiveShellInit = ''eval "$(direnv hook bash)"'';
  # INTERACTIVE SHELL INIT FOR ZSH IN .zsh.nix
}
