{
  description = "A flake providing both EndoReg Client Manager and AGL Anonymizer services in a CUDA enabled environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Ensure this URL is correct
  };

  outputs = { self, nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.cudaSupport = true;
    };
  in {
    nixosModules = {
      endoreg-client-manager = { config, pkgs, lib, ... }: {
        options.services.endoreg-client-manager = {
          enable = lib.mkEnableOption "Enable EndoReg Client Manager services";
          user = lib.mkOption {
            type = lib.types.str;
            default = "endoreg";
            description = "The user under which the EndoReg Client Manager will run";
          };

          group = lib.mkOption {
            type = lib.types.str;
            default = "endoreg";
            description = "The group under which the EndoReg Client Manager will run";
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
            default = "/home/agl-admin/endoreg-client-manager/endoreg_client_manager";
            description = "The working directory for the EndoReg Client Manager";
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
            default = "endoreg_client_manager.settings";
            description = "The Django settings module";
          };

          django-port = lib.mkOption {
            type = lib.types.int;
            default = 9000;
            description = "The port on which the Django server will listen";
          };

          conf = lib.mkOption {
            type = lib.types.attrsOf lib.types.any;
            default = {};
            description = "Other settings";
          };
        };

        config = lib.mkIf config.services.endoreg-client-manager.enable {
          environment.systemPackages = with pkgs; [
            redis
            cudaPackages.cudatoolkit
            libGLU libGL
            glibc
            xorg.libXi xorg.libXmu freeglut
            xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
            ncurses5 stdenv.cc binutils
          ];

          services.redis.servers."endoreg-client-manager" = {
            enable = true;
            bind = config.services.endoreg-client-manager.redis-bind;
            port = config.services.endoreg-client-manager.redis-port;
            settings = {};
          };

          systemd.services.endoreg-client-manager = {
            description = "EndoReg Client Manager Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Restart = "always";
              User = config.services.endoreg-client-manager.user;
              Group = config.services.endoreg-client-manager.group;
              WorkingDirectory = "${config.services.endoreg-client-manager.working-directory}";
              Environment = [
                "PATH=${config.services.endoreg-client-manager.working-directory}/.venv/bin:/run/current-system/sw/bin"
                "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
                "CUDA_PATH=${pkgs.cudatoolkit}"
                "DJANGO_SETTINGS_MODULE=${config.services.endoreg-client-manager.django-settings-module}"
              ];
            };
            script = ''
              export DJANGO_SECRET_KEY=${config.services.endoreg-client-manager.django-secret-key}
              nix develop
              exec gunicorn endoreg_client_manager.wsgi:application --bind 0.0.0.0:${toString config.services.endoreg-client-manager.django-port}
            '';
          };

          systemd.services.endoreg-client-manager-celery = {
            description = "EndoReg Client Manager Celery Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Restart = "always";
              User = config.services.endoreg-client-manager.user;
              Group = config.services.endoreg-client-manager.group;
              WorkingDirectory = "${config.services.endoreg-client-manager.working-directory}";
              Environment = [
                "PATH=${config.services.endoreg-client-manager.working-directory}/.venv/bin:/run/current-system/sw/bin"
                "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
                "CUDA_PATH=${pkgs.cudatoolkit}"
                "DJANGO_SETTINGS_MODULE=${config.services.endoreg-client-manager.django-settings-module}"
              ];
            };
            script = ''
              nix develop
              exec celery -A endoreg_client_manager worker --loglevel=info
            '';
          };

          systemd.services.endoreg-client-manager-celery-beat = {
            description = "EndoReg Client Manager Celery Beat Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Restart = "always";
              User = config.services.endoreg-client-manager.user;
              Group = config.services.endoreg-client-manager.group;
              WorkingDirectory = "${config.services.endoreg-client-manager.working-directory}";
              Environment = [
                "PATH=${config.services.endoreg-client-manager.working-directory}/.venv/bin:/run/current-system/sw/bin"
                "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
                "CUDA_PATH=${pkgs.cudatoolkit}"
                "DJANGO_SETTINGS_MODULE=${config.services.endoreg-client-manager.django-settings-module}"
              ];
            };
            script = ''
              nix develop
              exec celery -A endoreg_client_manager beat --loglevel=INFO --scheduler django_celery_beat.schedulers:DatabaseScheduler
            '';
          };
        };
      };

      agl-anonymizer = { config, pkgs, lib, ... }: {
        options.services.agl-anonymizer = {
          enable = lib.mkEnableOption "Enable AGL Anonymizer service";
          user = lib.mkOption {
            type = lib.types.str;
            default = "endoreg";
            description = "The user under which the AGL Anonymizer service will run";
          };

          group = lib.mkOption {
            type = lib.types.str;
            default = "endoreg";
            description = "The group under which the AGL Anonymizer service will run";
          };

          django-settings-module = lib.mkOption {
            type = lib.types.str;
            default = "agl_anonymizer.settings";
            description = "The Django settings module for the AGL Anonymizer";
          };

          django-port = lib.mkOption {
            type = lib.types.int;
            default = 9123;
            description = "The port on which the Django server will listen";
          };

          working-directory = lib.mkOption {
            type = lib.types.str;
            default = "/home/agl-admin/agl_anonymizer/agl_anonymizer";
            description = "The working directory for the AGL Anonymizer module";
          };
        };

        config = lib.mkIf config.services.agl-anonymizer.enable {
          environment.systemPackages = with pkgs; [
            libGLU libGL
            glibc
            xorg.libXi xorg.libXmu freeglut
            xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
            ncurses5 stdenv.cc binutils
          ];

          systemd.services.agl-anonymizer = {
            description = "AGL Anonymizer Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Restart = "always";
              User = config.services.agl-anonymizer.user;
              Group = config.services.agl-anonymizer.group;
              WorkingDirectory = "${config.services.agl-anonymizer.working-directory}";
              EnvironmentFile = "${config.services.agl-anonymizer.working-directory}/.env";
              Environment = [
                "PATH=${config.services.agl-anonymizer.working-directory}/.venv/bin:/run/current-system/sw/bin"
                "DJANGO_SETTINGS_MODULE=${config.services.agl-anonymizer.django-settings-module}"
                "PYTHONPATH=${config.services.agl-anonymizer.working-directory}"
              ];
            };
            script = ''
              nix develop
              export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
              export LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.zlib}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libGL}/lib:${pkgs.libGLU}/lib:${pkgs.glib}/lib:${pkgs.glibc}/lib:$LD_LIBRARY_PATH"
              export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
              export EXTRA_CCFLAGS="-I/usr/include"
              export CUDA_NVCC_FLAGS="--compiler-bindir=$(which gcc)"
              source ${config.services.agl-anonymizer.working-directory}/.venv/bin/activate
              exec gunicorn agl_anonymizer.wsgi:application --bind 0.0.0.0:${toString config.services.agl-anonymizer.django-port}
            '';
          };

        };
      };
    };

    nixosConfigurations = {
      "default" = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          self.nixosModules.endoreg-client-manager
          self.nixosModules.agl-anonymizer
        ];
      };
    };
  };
}
