{ pkgs, ... }: {

  environment.systemPackages = [  # with pkgs; [
    pkgs.opencv
  ];
}