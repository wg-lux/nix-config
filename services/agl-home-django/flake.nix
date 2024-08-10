{
  description = "A flake providing both EndoReg Home Server Application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # Ensure this URL is correct
  };

  outputs = { self, nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.cudaSupport = false;
    };
  in {
    nixosModules = {
      agl-home-django = { config, pkgs, lib, ... }: {
        options.services.agl-home-django = {
          enable = lib.mkEnableOption "Enable AGL Home Django Server";
          user = lib.mkOption {
            type = lib.types.str;
            default = "agl-admin";
            description = "The user under which the AGL Home Django Server will run";
          };

          group = lib.mkOption {
            type = lib.types.str;
            default = "agl-admin";
            description = "The group under which the AGL Home Django Server will run";
          };

          redis-port = lib.mkOption {
            type = lib.types.int;
            default = 6379;
            description = "The port on which the Redis server will listen";
          };

          redis-bind = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "The address on which the Redis server will listen";
          };

          working-directory = lib.mkOption {
            type = lib.types.str;
            default = "/home/agl-admin/agl-home-django";
            description = "The working directory for the AGL Home Django Server";
          };

          django-secret-key = lib.mkOption {
            type = lib.types.str;
            default = "CHANGE_ME";
            description = "The secret key for the Django application";
          };

          django-debug = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable Django debug mode";
          };

          django-settings-module = lib.mkOption {
            type = lib.types.str;
            default = "endoreg_home.settings_prod";
            description = "The Django settings module";
          };

          django-port = lib.mkOption {
            type = lib.types.int;
            default = 9100;
            description = "The port on which the Django server will listen";
          };

          conf = lib.mkOption {
            type = lib.types.attrsOf lib.types.any;
            default = {};
            description = "Other settings";
          };
        };

        config = lib.mkIf config.services.agl-home-django.enable {
          environment.systemPackages = with pkgs; [
            redis
            cudaPackages.cudatoolkit
            libGLU libGL
            glibc
            xorg.libXi xorg.libXmu freeglut
            xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
            ncurses5 stdenv.cc binutils
          ];

          services.redis.servers."agl-home-django" = {
            enable = true;
            bind = config.services.agl-home-django.redis-bind;
            port = config.services.agl-home-django.redis-port;
            settings = {};
          };

          systemd.services.agl-home-django = {
            description = "agl-home-django Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Restart = "always";
              User = config.services.agl-home-django.user;
              Group = config.services.agl-home-django.group;
              WorkingDirectory = "${config.services.agl-home-django.working-directory}/endoreg_home";
              Environment = [
                "PATH=${config.services.agl-home-django.working-directory}/.venv/bin:/run/current-system/sw/bin"
                "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
                "CUDA_PATH=${pkgs.cudatoolkit}"
                "DJANGO_SETTINGS_MODULE=${config.services.agl-home-django.django-settings-module}"
              ];
            };
            script = ''
              export DJANGO_SECRET_KEY=${config.services.agl-home-django.django-secret-key}
              nix develop
              exec gunicorn endoreg_home.wsgi:application --bind 0.0.0.0:${toString config.services.agl-home-django.django-port}
            '';
          };

          systemd.services.agl-home-django-celery = {
            description = "AGL Home Django Celery Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Restart = "always";
              User = config.services.agl-home-django.user;
              Group = config.services.agl-home-django.group;
              WorkingDirectory = "${config.services.agl-home-django.working-directory}/endoreg_home";
              Environment = [
                "PATH=${config.services.agl-home-django.working-directory}/.venv/bin:/run/current-system/sw/bin"
                "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
                "CUDA_PATH=${pkgs.cudatoolkit}"
                "DJANGO_SETTINGS_MODULE=${config.services.agl-home-django.django-settings-module}"
              ];
            };
            script = ''
              nix develop
              exec celery -A agl_home_django worker --loglevel=info
            '';
          };

          systemd.services.agl-home-django-celery-beat = {
            description = "agl-home-django Celery Beat Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Restart = "always";
              User = config.services.agl-home-django.user;
              Group = config.services.agl-home-django.group;
              WorkingDirectory = "${config.services.agl-home-django.working-directory}/endoreg_home";
              Environment = [
                "PATH=${config.services.agl-home-django.working-directory}/.venv/bin:/run/current-system/sw/bin"
                "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
                "CUDA_PATH=${pkgs.cudatoolkit}"
                "DJANGO_SETTINGS_MODULE=${config.services.agl-home-django.django-settings-module}"
              ];
            };
            script = ''
              nix develop
              exec celery -A agl_home_django beat --loglevel=INFO --scheduler django_celery_beat.schedulers:DatabaseScheduler
            '';
          };
        };
      };

    };

  };
}
