{ pkgs, ... }: {

  environment.systemPackages =  with pkgs; [
    # ffmpeg_4 # maybe for compatibility if newer versions break something
    ffmpeg_7
  ];
}
