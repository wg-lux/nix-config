{...}:
{

  #home.file.".config" = {
  #  source = ./files/.config;
  #  target = "./.config";
  #  recursive = true;
  #};

  home.file.".background-image" = {
    source = ./files/backgrounds/agl_wallpaper.png;
    target = "./.background-image.png";
    recursive = true;
  };

}