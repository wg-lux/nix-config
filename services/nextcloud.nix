{config, pkgs, agl-network-config, ...}:

let
	hostname = config.networking.hostName;
	nextcloud-secret-path = ../secrets + ("/" + "${hostname}/services/nextcloud.yaml");
	nextcloud-system-user = agl-network-config.services.nextcloud.user;
	nextcloud-system-group = agl-network-config.services.nextcloud.group;
	nextcloud-port = agl-network-config.services.nextcloud.port;
	nextcloud-domain = agl-network-config.services.nextcloud.domain;
    nextcloud-db-name = agl-network-config.services.nextcloud.db-name;
	nextcloud-db-type = agl-network-config.services.nextcloud.db-type;

	main-nginx-ip = agl-network-config.services.nextcloud.proxy-ip;
	
in
	{
        # Nextcloud secret
		sops.secrets."services/nextcloud/admin-pass" = {
			sopsFile = nextcloud-secret-path;
			path = "/etc/nextcloud-admin-pass";
            # key = "services/nextcloud/admin-pass"; # by default same as sops.secrets."X", but can be changed
            ## especially useful if you want to use the same secret in multiple places / with multiple users
			# owner = config.systemd.services.nextcloud.serviceConfig.User;
            owner = nextcloud-system-user;
	    };

        # Mysql secrets
        # sops.secrets."services/nextcloud/mysql-root-pass" = {
        #     sopsFile = ../secrets + ("/" + "${hostname}/services/mysql.yaml");
        #     path = "/etc/mysql-root-pass";
        #     owner = "root";
        # };




        # Configure Firewall
        networking.firewall.allowedTCPPorts = [ 80 443 ];

        # set up db
        services.mysql = {
            enable = true;
            package = pkgs.mariadb;
            ensureDatabases = [ "nextcloud" ];
            ensureUsers = [
                {
                    name = nextcloud-system-user;
                    ensurePermissions = {
                        "nextcloud.*" = "ALL PRIVILEGES";
                    };
                }
            ];
            dataDir = "/var/lib/mysql"; # default

            # override default settings EXAMPLE
            # configFile = pkgs.writeText "my.cnf" ''
            #     [mysqld]
            #     datadir = /var/lib/mysql
            #     bind-address = 127.0.0.1
            #     port = 3336

            #     !includedir /etc/mysql/conf.d/
            # '';
        };


		services.nextcloud = {
			enable = true;
			package = pkgs.nextcloud28;
			hostName = hostname;
            # hostName = "agl-nextcloud";
			https = true;


            database.createLocally = true;
			config = {
                # dbtype = "pgsql";
				adminuser = nextcloud-system-user;
				adminpassFile = config.sops.secrets."services/nextcloud/admin-pass".path;
                dbuser = nextcloud-system-user;
                dbtype = "mysql";
                dbname = nextcloud-db-name;
                # dbhost = "localhost:9000"; # not necessary for mysql + create locally
                # dbpassFile = config.sops.secrets."services/nextcloud/mysql-root-pass".path; # not necessary for mysql + create locally
            };
			home = "/var/lib/nextcloud"; # default TODO: point to mounted folder (check if nfs-share is still working)

			settings = {
				trusted_proxies = [
					main-nginx-ip
				];

				trusted_domains = [
					nextcloud-domain
				];

                overwriteprotocol = "https";
				"profile.enabled" = true;

                default_phone_region = "DE";
			
				# skeletondirectory = ""; The directory where the skeleton files are located. These files will be copied to the data directory of new users. Leave empty to not copy any skeleton files.
			};
			
			autoUpdateApps.enable = true;
            autoUpdateApps.startAt = "05:00:00";

			enableImagemagick = true; 
			
            notify_push = {
                enable = true;
                # dbuser = ;          # default is config.services.nextcloud.config.dbuser

                dbtype = "mysql";
            };
			# notify_push.socketPath = "/run/nextcloud-notify_push/sock"; # default

			configureRedis = true; # default is same as notify_push.enable

			# Data Dir #
			# datadir = INSERT DATA DIR # Default is config.services.nextcloud.home

			# Secret File 
			## Secret options which will be appended to Nextcloud’s config.php file (written as JSON, in the same form as the [services.nextcloud.settings](https://search.nixos.org/options?channel=unstable&show=services.nextcloud.settings&query=services.nextcloud.settings) option), for example `{"redis":{"password":"secret"}}`.
			# secretFile =  # POINT TO SECRET FILE

			# Extra Apps
			# https://search.nixos.org/options?channel=24.05&show=services.nextcloud.extraApps&from=0&size=50&sort=relevance&type=packages&query=nextcloud
			
			# extraApps = {
			# inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
			# };
			# extraAppsEnable = true;
		};
		
	}