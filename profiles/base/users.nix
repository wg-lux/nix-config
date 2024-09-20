{ config, pkgs, inputs, 
openvpn-cert-path, users-mutable ? true,
... }:

let
  hostname = config.networking.hostName;

in
  {
    imports =
      [ 
        inputs.home-manager.nixosModules.home-manager
        ./groups.nix
        ( import ./secrets.nix { inherit hostname openvpn-cert-path; } )
      ];

    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      users = {
        agl-admin = import ../../users/agl-admin/home.nix;
        maintenance-user = import ../../users/maintenance-user/home.nix;
        center-user = import ../../users/center-user/home.nix;
      };
    };


    # users.mutableUsers = false;
    users.mutableUsers = users-mutable;

    users.users = {
      agl-admin = {
        isNormalUser = true;
        description = "agl-admin";
        hashedPasswordFile = config.sops.secrets."user/nix/agl-admin/pwd".path;
        extraGroups = [ 
          "networkmanager" 
          "wheel" 
          "video" 
          "sound"
          "audio"
          "pulse-access"
        ];

        # shell = pkgs.zsh;
        packages = with pkgs; [
          firefox
          vscode
        ];
      };
      
      center-user = {
        isNormalUser = true;
        description = "Center User";
        hashedPasswordFile = config.sops.secrets."user/nix/center-user/pwd".path;
        extraGroups = [ 
          "audio" 
          "sound"
        ];
      };
      service-user = {
        isSystemUser = true;
        description = "Endoreg Service User";
        extraGroups = [ "networkmanager" "wheel" ];
        group = "service-user";
        hashedPasswordFile = config.sops.secrets."user/nix/service-user/pwd".path;
        packages = with pkgs; [
        ];
      };
      maintenance-user = {
        isNormalUser = true;
        description = "Maintenance User";
        extraGroups = [ "networkmanager" "wheel" ];
        hashedPasswordFile = config.sops.secrets."user/nix/maintenance-user/pwd".path;
        shell = pkgs.bash;
        packages = with pkgs; [
          firefox
          vscode
        ];
      };
      # default_user = {
      #   isNormalUser = true;
      #   description = "default / empty";
      #   extraGroups = [ "networkmanager" ];
      #   hashedPasswordFile = config.sops.secrets."nix_user/default-user/pwd".path;
      #   packages = with pkgs; [
      #     firefox
      #     vscode
      #   ];
      # };
    };
  }