{ pkgs, ... }:
  {
    users.users = {
      uke = {
        isNormalUser = true;
        description = "UKE";
        extraGroups = [ "networkmanager" ];
        shell = pkgs.bash;
        packages = with pkgs; [
          firefox
          vscode
        ];
      };
    };
  }