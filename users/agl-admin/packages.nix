{pkgs}: {

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.packages = [
    pkgs.openssh
    pkgs.spotify
    pkgs.google-chrome
    # chromium
  ];

  programs.chromium = {
    enable = true;
  };
}