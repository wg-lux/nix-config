{
  description = "A flake providing a Django Server to monitor AGL Network Devices";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.cudaSupport = false;
        };
        
    in
        {
          nixosModules = {
            agl-monitor = { config, pkgs, lib, ... }: {
              options.services.agl-monitor = {
                enable = lib.mkEnableOption "Enable AGL Monitor Server";
                user = lib.mkOption {
                  type = lib.types.str;
                  default = "agl-admin";
                  description = "The user under which the AGL Monitor Server will run";
                };

                group = lib.mkOption {
                  type = lib.types.str;
                  default = "agl-admin";
                  description = "The group under which the AGL Monitor Server will run";
                };

                working-directory = lib.mkOption {
                  type = lib.types.str;
                  #TODO change this to a neutral path
                  default = "/home/agl-admin/agl-monitor";
                  description = "The working directory for the AGL Monitor Server";
                };



                django-debug = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Enable Django debug mode";
                };

                django-settings-module = lib.mkOption {
                  type = lib.types.str;
                  default = "agl_monitor.settings_prod";
                  description = "The settings module for the Django application";
                };

                # Define the port on which the Django server will listen
                django-port = lib.mkOption {
                  type = lib.types.int;
                  default = 8825;
                  description = "The port on which the Django server will listen";
                };

                # Define the address on which the Django server will listen
                bind = lib.mkOption {
                  type = lib.types.str;
                  default = "172.16.255.4";
                  description = "The address on which the Django server will listen";
                };

                redis-port = lib.mkOption {
                  type = lib.types.int;
                  default = 6463; #FIXME: currently isnt used, the port is currently defined via config file (agl-monitor.json)
                  description = "The port on which the Redis server will listen"; 
                };

                redis-bind = lib.mkOption {
                  type = lib.types.str;
                  default = "127.0.0.1";
                  description = "The address on which the Redis server will listen";
                };

                conf = lib.mkOption {
                  type = lib.types.attrsOf lib.types.any;
                  default = {};
                  description = "Other settings";
                };
              };

          config = lib.mkIf config.services.agl-monitor.enable {

            environment.systemPackages = with pkgs; [
            redis
            libGLU libGL
            glibc
            xorg.libXi xorg.libXmu freeglut
            xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
            ncurses5 stdenv.cc binutils

            poetry
            ];


            services.redis.servers."agl-monitor" = {
              enable = true;
              bind = config.services.agl-monitor.redis-bind;
              port = config.services.agl-monitor.redis-port;
              settings = {};
            };

            systemd.services.agl-monitor = {
              description = "AGL Monitor Django Server Service";
              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                Restart = "always";
                User = config.services.agl-monitor.user;
                Group = config.services.agl-monitor.group;
                WorkingDirectory = "${config.services.agl-monitor.working-directory}/agl_monitor";
                Environment = [
                  "PATH=${config.services.agl-monitor.working-directory}/.venv/bin:/run/current-system/sw/bin"
                  "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
                  "DJANGO_SETTINGS_MODULE=${config.services.agl-monitor.django-settings-module}"
                ];
              };
              script = ''
                nix develop
                exec gunicorn agl_monitor.wsgi:application --bind ${config.services.agl-monitor.bind}:${toString config.services.agl-monitor.django-port}
              '';
            };

            systemd.services.agl-monitor-celery = {
              description = "AGL Home Django Celery Service";
              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                Restart = "always";
                User = config.services.agl-monitor.user;
                Group = config.services.agl-monitor.group;
                WorkingDirectory = "${config.services.agl-monitor.working-directory}/agl_monitor";
                Environment = [
                  "PATH=${config.services.agl-monitor.working-directory}/.venv/bin:/run/current-system/sw/bin"
                  "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
                  "DJANGO_SETTINGS_MODULE=${config.services.agl-monitor.django-settings-module}"
                ];
              };
              script = ''
                nix develop
                exec celery -A agl_monitor worker --loglevel=info
              '';
            };

            systemd.services.agl-monitor-celery-beat = {
              description = "agl-monitor Celery Beat Service";
              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                Restart = "always";
                User = config.services.agl-monitor.user;
                Group = config.services.agl-monitor.group;
                WorkingDirectory = "${config.services.agl-monitor.working-directory}/agl_monitor";
                Environment = [
                  "PATH=${config.services.agl-monitor.working-directory}/.venv/bin:/run/current-system/sw/bin"
                  "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
                  "DJANGO_SETTINGS_MODULE=${config.services.agl-monitor.django-settings-module}"
                ];
              };
              script = ''
                nix develop
                exec celery -A agl_monitor beat --loglevel=INFO --scheduler django_celery_beat.schedulers:DatabaseScheduler
              '';
            };
          };
        
        };
      };
  };
}
