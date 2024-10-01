{ config, pkgs, inputs, agl-network-config,
openvpn-config, users-mutable ? true,
... }:

let
  hostname = config.networking.hostName;
  openvpn-cert-path = openvpn-config.cert-path;

  admin-user-name = agl-network-config.service-configs.admin-user;

  maintenance-user-name = agl-network-config.service-configs.maintenance-user;
  service-user-name = agl-network-config.service-configs.service-user;
  service-group = agl-network-config.service-configs.service-group;
  openvpn-user-name = openvpn-config.user;
  logging-user-name = agl-network-config.service-configs.logging-user;

  center-user-name = agl-network-config.service-configs.center-user;

  admin-user-extra-groups = agl-network-config.service-configs.admin-user-extra-groups;
  base-user-extra-groups = agl-network-config.service-configs.base-user-extra-groups;
  service-user-extra-groups = agl-network-config.service-configs.service-user-extra-groups;

in
  {
    imports =
      [ 
        inputs.home-manager.nixosModules.home-manager 
      ];

    home-manager = {
			# backupFileExtension = "~backup";
      extraSpecialArgs = { inherit inputs agl-network-config; };
      users = {
        "${admin-user-name}" = import ../../users/${admin-user-name}/home.nix;
        "${maintenance-user-name}"  = import ../../users/${maintenance-user-name}/home.nix;
        "${center-user-name}"  = import ../../users/${center-user-name}/home.nix;
      };
    };

    # users.mutableUsers = false;
    users.mutableUsers = users-mutable;

    users.users = {
      "${admin-user-name}" = {
        isNormalUser = true;
        description = "${admin-user-name}";
        hashedPasswordFile = config.sops.secrets."user/nix/${admin-user-name}/pwd".path;
        extraGroups = admin-user-extra-groups;

        # shell = pkgs.zsh;
        packages = with pkgs; [
          firefox
          vscode
        ];
      };
      
      "${center-user-name}" = {
        isNormalUser = true;
        description = "Center User";
        hashedPasswordFile = config.sops.secrets."user/nix/${center-user-name}/pwd".path;
        extraGroups = base-user-extra-groups;
      };

      "${service-user-name}" = {
        isSystemUser = true;
        description = "Service User";
        extraGroups = service-user-extra-groups;
        group = service-group;
        hashedPasswordFile = config.sops.secrets."user/nix/${service-user-name}/pwd".path;
      };

      "${logging-user-name}" = {
        isSystemUser = true;
        description = "Logging User";
        extraGroups = service-user-extra-groups;
        group = service-group;
        # hashedPasswordFile = config.sops.secrets."user/nix/${logging-user-name}/pwd".path;
      };

      "${maintenance-user-name}" = {
        isNormalUser = true;
        description = "Maintenance User";
        extraGroups = service-user-extra-groups;
        hashedPasswordFile = config.sops.secrets."user/nix/${maintenance-user-name}/pwd".path;
        # shell = pkgs.bash;
        # packages = with pkgs; [
        #   firefox
        #   vscode
        # ];
      };

      # OpenVPN User
      "${openvpn-user-name}" = {
        isSystemUser = true;
        group = openvpn-config.group;
        description = "OpenVPN User";
        extraGroups = service-user-extra-groups;
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