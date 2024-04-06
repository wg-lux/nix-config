{ pkgs, ... }: {

  environment.systemPackages = [  # with pkgs; [
    pkgs.ffmpeg_5
  ];
}
