{config, pkgs, agl-network-config, ...}:

let
	hostname = config.networking.hostName;
	nextcloud-secret-path = ../secrets + ("/" + "${hostname}/nextcloud.yaml");
	nextcloud-system-user = agl-network-config.services.nextcloud.user;
	nextcloud-system-group = agl-network-config.services.nextcloud.group;
	nextcloud-port = agl-network-config.services.nextcloud.port;
	nextcloud-domain = agl-network-config.services.nextcloud.nextcloud-domain;
	
	main-nginx-ip = agl-network-config.services.nextcloud.proxy-ip;
	
in
	{
		environment.etc."nextcloud-admin-pass".text = "PWD";
		sops.secrets."services/nextcloud/admin-pass" = {
			sopsFile = nextcloud-secret-path;
			path = "/etc/nextcloud-admin-pass";
			user = nextcloud-system-user;
			group = nextcloud-system-group;
	};

  

		services.nextcloud = {
			enable = true;
			package = pkgs.nextcloud28;
			hostName = hostname;
			https = true;
			config = {
				adminuser = "root";
				adminpassFile = config.sops.secrets."services/nextcloud-admin-pass".path;
			};
			home = "/var/lib/nextcloud"; # default TODO: point to mounted folder (check if nfs-share is still working)

			settings = {
				trusted_proxies = [
					main-nginx-ip
				];

				trusted_domains = [
					nextcloud-domain
				];
				"profile.enabled" = true;
			
				# skeletondirectory = ""; The directory where the skeleton files are located. These files will be copied to the data directory of new users. Leave empty to not copy any skeleton files.
			};
			
			autoUpdateApps.enable = true;
			enableImagemagick = true; 
			notify_push.enable = true;
			notify_push.socketPath
			# configureRedis = true; # default is same as notify_push.enable

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