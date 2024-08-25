{
  description = "flake for agl-g-play, a Vue JS Frontend that will be used to validate the output from the AGL Network Devices";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      commonBuildInputs = with pkgs; [
        nodejs_22
        yarn
        nodePackages_latest.gulp
      ];

      # Define the shellHook for convenience
      commonShellHook = ''
        export PATH="$PATH:$(yarn global bin)"
      '';

    in
    {
      # Development shell environment
      devShell = pkgs.mkShell {
        buildInputs = commonBuildInputs;
        shellHook = commonShellHook;
      };

      # Define the frontend service as a NixOS module
      nixosModules = {
        agl-g-play = { config, pkgs, lib, ... }: {
          options.services.agl-g-play = {
            enable = lib.mkEnableOption "Enable the AGL Vue.js frontend service";
            working-directory = lib.mkOption {
              type = lib.types.str;
              default = "/home/agl-admin/agl-g-play";
              description = "The working directory for the Vue.js frontend service";
            };
            user = lib.mkOption {
              type = lib.types.str;
              default = "agl-admin";
              description = "The user under which the Vue.js frontend service will run";
            };
            
            bind = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              description = "The IP address on which the Vue.js frontend will listen";
            }; 

            group = lib.mkOption {
              type = lib.types.str;
              default = "agl-admin";
              description = "The group under which the Vue.js frontend service will run";
            };
            port = lib.mkOption {
              type = lib.types.int;
              default = 3000;
              description = "The port on which the Vue.js frontend will listen";
            };
            conf = lib.mkOption {
              type = lib.types.attrsOf lib.types.any;
              default = {};
              description = "Other settings for the frontend service";
            };
          };

          config = lib.mkIf config.services.agl-g-play.enable {
            environment.systemPackages = with pkgs; [ nodejs_22 yarn ];

            systemd.services.agl-g-play = {
              description = "AGL Vue.js Frontend Service";
              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                Restart = "always";
                User = config.services.agl-g-play.user;
                Group = config.services.agl-g-play.group;
                WorkingDirectory = config.services.agl-g-play.working-directory;
                Environment = [
                  "NODE_ENV=production"
                  "PATH=${config.services.agl-g-play.working-directory}/node_modules/.bin:/run/current-system/sw/bin"
                  
                ];
                #ExecStart = ''
                #  ${config.services.agl-g-play.working-directory}/node_modules/.bin/vue-cli-service serve --port ${toString config.services.agl-g-play.port} --host ${config.services.agl-g-play.bind}
                #'';
              };
                # export PATH="$PATH:$(yarn global bin)"
                #
              
              #TODO: implement "professional" startup command
              script = ''
                nix develop
                exec npm run start
              '';
            };
          };
        };
      };
    };
}