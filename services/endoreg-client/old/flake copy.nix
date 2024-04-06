{
  description = "A flake providing the EndoReg Client Manager services in a CUDA enabled environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cachix.url = "github:cachix/cachix";
    cachix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, cachix, ... }:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.cudaSupport = true; 
        };
      nvidiaCache = cachix.lib.mkCachixCache {
        inherit (pkgs) lib;
        name = "nvidia";
        publicKey = "nvidia.cachix.org-1:dSyZxI8geDCJrwgvBfPH3zHMC+PO6y/BT7O6zLBOv0w=";
        secretKey = null; # Not needed for pulling from the cache
      };
    in {

        # environment.systemPackages = [ pythonCudaEnvironment ];

        nixConfig = {
            binary-caches = [nvidiaCache.binaryCachePublicUrl];
            binary-cache-public-keys = [nvidiaCache.publicKey];
        };

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
            };

            config = lib.mkIf config.services.endoreg-client-manager.enable {
                
                # setup redis server:
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
                    # INSTALL REMAINING PYTHON PACKAGES USING POETRY
                    ## TODO

                    exec ${pythonCudaEnvironment}/bin/gunicorn endoreg_client_manager.wsgi:application --bind 0.0.0.0:${toString config.services.endoreg-client-manager.django-port}      
                    '';
                    serviceConfig = {
                        # ExecStart = "${pkgs.endoreg-client-manager}/bin/endoreg-client-manager"; # Adjust the path as needed
                        Restart = "always";
                        User = config.services.endoreg-client-manager.user;
                        Group = config.services.endoreg-client-manager.group;
                        WorkingDirectory = "${config.services.endoreg-client-manager.working-directory}/endoreg_client_manager";
                    };
                };

                endoreg-client-manager-celery = {
                    description = "EndoReg Client Manager Celery Service";
                    after = [ "network.target" ];
                    wantedBy = [ "multi-user.target" ];
                    script = ''
                        # INSTALL REMAINING PYTHON PACKAGES USING POETRY
                        ## TODO

                        exec ${pythonCudaEnvironment}/bin/python celery -A endoreg_client_manager worker --loglevel=INFO 
                    '';
                    serviceConfig = {
                        Restart = "always";
                        User = config.services.endoreg-client-manager.user;
                        Group = config.services.endoreg-client-manager.group;

                        Environment = [
                            "DJANGO_SETTINGS_MODULE=${config.services.endoreg-client-manager.django-settings-module}"
                            "DJANGO_SECRET_KEY=${config.services.endoreg-client-manager.django-secret-key}"
                            "DJANGO_DEBUG=${toString config.services.endoreg-client-manager.django-debug}"
                        ];
                        WorkingDirectory = "${config.services.endoreg-client-manager.working-directory}/endoreg_client_manager";
                    };
                };

                endoreg-client-manager-celery-beat = {
                    description = "EndoReg Client Manager Celery Beat Service";
                    after = [ "network.target" ];
                    wantedBy = [ "multi-user.target" ];
                    serviceConfig = {
                        # ExecStart = "";
                        # ExecStart = "${pkgs.endoreg-client-manager}/bin/endoreg-client-manager-celery-beat"; # Adjust
                        Restart = "on-failure";
                    };
                };
                };
            };
        };

    };

}
