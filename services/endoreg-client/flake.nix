{
  description = "A flake providing the EndoReg Client Manager services in a CUDA enabled environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # cachix.url = "github:cachix/cachix";
    # cachix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, cachix, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.cudaSupport = true;
    };

    # nvidiaCache = cachix.lib.mkCachixCache {
    #   inherit (pkgs) lib;
    #   name = "nvidia";
    #   publicKey = "nvidia.cachix.org-1:dSyZxI8geDCJrwgvBfPH3zHMC+PO6y/BT7O6zLBOv0w=";
    #   secretKey = null; # Not needed for pulling from the cache
    # };
  in {

    # nixConfig = {
    #   binary-caches = [nvidiaCache.binaryCachePublicUrl];
    #   binary-cache-public-keys = [nvidiaCache.publicKey];
    # };

    nixosModules.endoreg-client-manager = { config, pkgs, lib, ... }: {
      options.services.endoreg-client-manager = {
        enable = lib.mkEnableOption "Enable EndoReg services";
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

        # Redis
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

        # Django
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

        # Other settings as dictionary
        conf = lib.mkOption {
            type = lib.types.attrsOf lib.types.any;
            default = {};
            description = "Other settings";
        };
        agl-anonymizer-django-settings-module = lib.mkOption {
            type = lib.types.str;
            default = "agl_anonymizer.settings";
            description = "Agl Anonymizer Django settings";

        };
        agl-anonymizer-dir  = lib.mkOption {
            type = lib.types.str;
            default = "/home/agl-admin/agl_anonymizer/agl_anonymizer";
            description = "Agl Anonymizer path";

        };
        agl-anonymizer-port = lib.mkOption {
            type = lib.types.int;
            default = 9123;
            description = "The port on which the Django server for the AGL Anonymizer API will listen";
        };


      };

      config = lib.mkIf config.services.endoreg-client-manager.enable {
        # setup redis server:
        # environment.systemPackages = with pkgs; [
        #   redis
        #   cudaPackages.cudatoolkit
        #   # cudaPackages.cudnn
        #   # linuxPackages.nvidia_x11
        #   libGLU libGL
        #   glibc
        #   xorg.libXi xorg.libXmu freeglut
        #   xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib 
        #   ncurses5 stdenv.cc binutils
        # ];
        services.redis.servers."endoreg-client-manager"= { # results in service named: redis-endoreg-client-manager.service 
            enable = true;
            bind = config.services.endoreg-client-manager.redis-bind; 
            port = config.services.endoreg-client-manager.redis-port;
            settings = {};
        };

        systemd.services = {
          endoreg-client-manager = {
            description = "EndoReg Client Manager Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            script = ''
              # Activate the Python virtual environment
              export DJANGO_SECRET_KEY=$(cat ${config.services.endoreg-client-manager.working-directory}/.env/secret)
              nix develop
              
              # Now run gunicorn with our Python environment
              exec gunicorn endoreg_client_manager.wsgi:application --bind 0.0.0.0:${toString config.services.endoreg-client-manager.django-port}
            '';
            serviceConfig = {
              Restart = "always";
              User = config.services.endoreg-client-manager.user;
              Group = config.services.endoreg-client-manager.group;
              WorkingDirectory = "${config.services.endoreg-client-manager.working-directory}/endoreg_client_manager";
              Environment = [
                "PATH=${config.services.endoreg-client-manager.working-directory}/.venv/bin:/run/current-system/sw/bin"
                "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib" #
                "CUDA_PATH=${pkgs.cudatoolkit}"
                "DJANGO_SETTINGS_MODULE=${config.services.endoreg-client-manager.django-settings-module}"
              ];
            };
          };

          endoreg-client-manager-celery = {
            description = "EndoReg Client Manager Celery Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            script = ''
              nix develop
              exec celery -A endoreg_client_manager worker --loglevel=info
            '';
            serviceConfig = {
              Restart = "always";
              User = config.services.endoreg-client-manager.user;
              Group = config.services.endoreg-client-manager.group;
              WorkingDirectory = "${config.services.endoreg-client-manager.working-directory}/endoreg_client_manager";
              Environment = [
                "PATH=${config.services.endoreg-client-manager.working-directory}/.venv/bin:/run/current-system/sw/bin"
                "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib" #
                "CUDA_PATH=${pkgs.cudatoolkit}"
                "DJANGO_SETTINGS_MODULE=${config.services.endoreg-client-manager.django-settings-module}"
              ];
            };
          };

          endoreg-client-manager-celery-beat = {
            description = "EndoReg Client Manager Celery Beat Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            script = ''
              nix develop
              exec celery -A endoreg_client_manager beat --loglevel=INFO --scheduler django_celery_beat.schedulers:DatabaseScheduler
            '';
            serviceConfig = {
              Restart = "always";
              User = config.services.endoreg-client-manager.user;
              Group = config.services.endoreg-client-manager.group;
              WorkingDirectory = "${config.services.endoreg-client-manager.working-directory}/endoreg_client_manager";
              Environment = [
                "PATH=${config.services.endoreg-client-manager.working-directory}/.venv/bin:/run/current-system/sw/bin"
                "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib" #
                "CUDA_PATH=${pkgs.cudatoolkit}"
                "DJANGO_SETTINGS_MODULE=${config.services.endoreg-client-manager.django-settings-module}"
              ];
            };
          };
          # Additional libraries for the environment
          # environment.systemPackages = with pkgs; [
          #   redis
          #   cudaPackages.cudatoolkit
          #   libGLU
          #   libGL
          #   glibc
          #   xorg.libXi xorg.libXmu freeglut
          #   xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib 
          #   ncurses5 stdenv.cc binutils
          # ];

          # In the service configuration
          agl-anonymizer = {
            description = "Image Anonymizing Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            script = ''
              set -e  # Exit immediately if a command exits with a non-zero status
              export DJANGO_SECRET_KEY=CHANGE_ME
              nix develop
              exec gunicorn agl_anonymizer.wsgi:application --bind 0.0.0.0:${toString config.services.endoreg-client-manager.agl-anonymizer-port}
            '';
            serviceConfig = {
              Restart = "always";
              User = config.services.endoreg-client-manager.user;
              Group = config.services.endoreg-client-manager.group;
              WorkingDirectory = "${config.services.endoreg-client-manager.agl-anonymizer-dir}/agl_anonymizer";
              Environment = [
                "PATH=${config.services.endoreg-client-manager.working-directory}/.venv/bin:/run/current-system/sw/bin"
                "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.libGL}/lib:${pkgs.libGLU}/lib" 
                "CUDA_PATH=${pkgs.cudatoolkit}"
                "DJANGO_SETTINGS_MODULE=${config.services.endoreg-client-manager.django-settings-module}"
              ];
              StandardOutput = "journal";
              StandardError = "journal";
            };
          };


        };
      };
    };
    
    };

  
}
