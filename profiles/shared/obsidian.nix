{ pkgs, ... }: {

  nixpkgs.config.permittedInsecurePackages = [
              "electron-25.9.0" # Allow for Obsidian #FIXME #TODO
            ];

  environment.systemPackages = [  # with pkgs; [
    pkgs.obsidian
  ];
}
