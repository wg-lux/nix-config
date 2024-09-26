{pkgs}: {

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.packages = with pkgs; [
    openssh
    spotify
    google-chrome
    pciutils # Device utils
    usbutils
    screen # Separate terminal
  ];



  # programs.chromium = {
  #   enable = true;
  # };
}