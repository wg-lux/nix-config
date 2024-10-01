{config, pkgs, agl-network-config, ...}:

let
	hostname = config.networking.hostName;
	nextcloud-secret-path = ../secrets + ("/" + "${hostname}/services/nextcloud.yaml");
	nextcloud-system-user = agl-network-config.services.nextcloud.user;
	nextcloud-system-group = agl-network-config.services.nextcloud.group;
	nextcloud-port = agl-network-config.services.nextcloud.port;
	nextcloud-local-port = agl-network-config.services.nextcloud.local-port;
	nextcloud-domain = agl-network-config.services.nextcloud.domain;
    nextcloud-db-name = agl-network-config.services.nextcloud.db-name;
	nextcloud-db-type = agl-network-config.services.nextcloud.db-type;
	nextcloud-host-ip = agl-network-config.services.nextcloud.ip;
	nextcloud-public-url = agl-network-config.services.nextcloud.public-url;

	proxy-ip = agl-network-config.services.nextcloud.proxy-ip;

	nexcloud-hostname = "https://${nextcloud-host-ip}:${toString nextcloud-port}";

	restrict-access-extraConfig = ''
        allow 127.0.0.1;
        allow ${agl-network-config.services.main_nginx.ip};
        allow ${nextcloud-host-ip};
        deny all;
    '';

	prot = "http";
	host = "127.0.0.1";
	dir = "nextcloud";

	all-extraConfig = ''
		proxy_headers_hash_bucket_size 128;
	'';
	
in
	{

        environment.etc."nextcloud-admin-pass".text = "init-admin-pass";
		# allow port 80 / 443
		networking.firewall.allowedTCPPorts = [ 80 443 ];

		# REQUIRES LOCAL-NGINX CONFIG TO BE LOADED
		services.nginx.virtualHosts = {
			"nextcloud.endo-reg.net" = {
				locations = {
					"/" = {
						proxyPass = "http://127.0.0.1:${toString nextcloud-local-port}/";
						proxyWebsockets = true;
						extraConfig = all-extraConfig;
					};
				};
				listen = [
					# { addr = nextcloud-host-ip; port = 80; }
					# { addr = nextcloud-host-ip; port = 443; }
					{ addr = "localhost"; port = 80; }
					{ addr = "localhost"; port = 443; }
					{ addr = "nextcloud.endo-reg.net"; port = 80; }
					{ addr = "nextcloud.endo-reg.net"; port = 443; }
					# { addr = "127.0.0.1"; port = 80; }
					# { addr = "127.0.0.1"; port = 443; }
				];
			};
			# "${nextcloud-host-ip}" = {
			# 	locations = {
			# 		"/" = {
			# 			proxyPass = "http://127.0.0.1:${toString nextcloud-local-port}/";
			# 			proxyWebsockets = true;
			# 			extraConfig = all-extraConfig;
			# 		};
			# 	};
			# };
			# "localhost" = {
			# 	locations = {
			# 		"/" = {
			# 			proxyPass = "http://127.0.0.1:${toString nextcloud-local-port}/";
			# 			proxyWebsockets = true;
			# 			extraConfig = all-extraConfig;
			# 		};
			# 	};
			# };
		};

		####

		services.nextcloud = {
			enable = true;
			package = pkgs.nextcloud29;
			hostName = nexcloud-hostname;
	

			settings = {
				overwriteprotocol = prot;
				overwritehost = host;
				overwritewebroot = dir;
				overwrite.cli.url = "${prot}$://{host}/${dir}/";
				htaccess.RewriteBase = dir;
								# Define other trusted domais apart from hostname here
				# trusted_domains = [];
				# trusted_proxies = [proxy-ip];
			};

            # database.createLocally = true;
			config = {
				# adminuser = nextcloud-system-user;
				# adminpassFile = config.sops.secrets."services/nextcloud/admin-pass".path;
                adminpassFile = "/etc/nextcloud-admin-pass";
                # dbuser = "root";
                # dbtype = nextcloud-db-type;
                # dbname = nextcloud-db-name;
                # dbhost = "localhost:9000"; # not necessary for mysql + create locally
                # dbpassFile = config.sops.secrets."services/nextcloud/mysql-root-pass".path; # not necessary for mysql + create locally
            };
			# home = "/var/lib/nextcloud"; # default TODO: point to mounted folder (check if nfs-share is still working)

			# settings = {
			# 	trusted_proxies = [
			# 		proxy-ip
			# 	];

			# 	trusted_domains = [
			# 		nextcloud-domain
			# 	];

            #     overwriteprotocol = "https";
			# 	"profile.enabled" = true;

            #     default_phone_region = "DE";
			
			# 	# skeletondirectory = ""; The directory where the skeleton files are located. These files will be copied to the data directory of new users. Leave empty to not copy any skeleton files.
			# };
			
			# autoUpdateApps.enable = true;
            # autoUpdateApps.startAt = "05:00:00";

			# enableImagemagick = true; 
			
            # notify_push = {
            #     enable = true;
            #     dbuser = nextcloud-system-user; # default is config.services.nextcloud.config.dbuser

            #     # dbtype = nextcloud-db-type; # default is config.services.nextcloud.config.dbtype
            # };
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






	#####


	        # Nextcloud secret
		# sops.secrets."services/nextcloud/admin-pass" = {
		# 	sopsFile = nextcloud-secret-path;
		# 	path = "/etc/nextcloud-admin-pass";
        #     # key = "services/nextcloud/admin-pass"; # by default same as sops.secrets."X", but can be changed
        #     ## especially useful if you want to use the same secret in multiple places / with multiple users
		# 	# owner = config.systemd.services.nextcloud.serviceConfig.User;
        #     owner = nextcloud-system-user;
	    # };

        # Configure Firewall
        # networking.firewall.allowedTCPPorts = [ nextcloud-port ];



					# "nextcloud.endo-reg.net" = {
			# 	# listen = [
			# 	#     { addr = ip; port = local-nginx-port; }
			# 	# ];
			# 	locations = {
			# 			"/nextcloud/" = {
			# 				proxyPass = "http://127.0.0.1:${toString config.services.nextcloud.local-port}/";
			# 				proxyWebsockets = true;
			# 				extraConfig = restrict-access-extraConfig + ''
			# 					proxy_set_header X-Real-IP $remote_addr;
			# 					proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			# 					proxy_set_header X-NginX-Proxy true;
			# 					proxy_set_header X-Forwarded-Proto http;
			# 					proxy_pass http://127.0.0.1:8080/; # tailing / is important!
			# 					proxy_set_header Host $host;
			# 					proxy_cache_bypass $http_upgrade;
			# 					proxy_redirect off;
			# 				'';
			# 		};
			# 	};
			# };