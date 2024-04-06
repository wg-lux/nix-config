{pkgs}: {

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.packages = [
    pkgs.firefox
  ];
}