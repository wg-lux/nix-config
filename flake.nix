{
  description = "AGL Nix Config";

nixConfig = {
# extra-substituters = [
#   "https://nix-community.cachix.org"
# ];
# extra-trusted-public-keys = [
#   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
# ];

substituters = [
		"https://cache.nixos.org"
		"https://cuda-maintainers.cachix.org"
	];
trusted-public-keys = [
		"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
		"cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
	];
};


inputs = {
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
	home-manager = {
		url = "github:nix-community/home-manager/release-24.05";
		inputs.nixpkgs.follows = "nixpkgs";
	};


	nix-index-database.url = "github:Mic92/nix-index-database";
	nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

	sops-nix.url = "github:Mic92/sops-nix";
	sops-nix.inputs.nixpkgs.follows = "nixpkgs";

	vscode-server.url = "github:nix-community/nixos-vscode-server";
	vscode-server.inputs.nixpkgs.follows = "nixpkgs";

	# add for flake usage with nixos stable
	flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

	# CUSTOM SERVICES
	### Example
	# customService.url = "./services/custom-service-flake"; # Adjust the path accordingly
	# customService.inputs.nixpkgs.follows = "nixpkgs";

	## EndoReg Client Manager
	# endoreg-client-manager.url = "github:wg-lux/endoreg-client-manager";
	endoreg-client-manager.url = "./services/endoreg-client";
	endoreg-client-manager.inputs.nixpkgs.follows = "nixpkgs";

	## AGL Home Django
	# agl-home-django.url = "github:wg-lux/agl-home-django";
	agl-home-django.url = "./services/agl-home-django";
	agl-home-django.inputs.nixpkgs.follows = "nixpkgs";

	## AGL Monitor
	# agl-monitor.url = "github:wg-lux/agl-monitor";
	agl-monitor.url = "./services/agl-monitor";
	agl-monitor.inputs.nixpkgs.follows = "nixpkgs";

	## AGL G-Play Validator
	# agl-g-play-validator.url = "github:wg-lux/agl-g-play-validator";
	agl-g-play.url = "./services/agl-g-play";
	agl-g-play.inputs.nixpkgs.follows = "nixpkgs";

	monitor-flake.url = "github:wg-lux/agl-monitor-flake";
	monitor-flake.inputs.nixpkgs.follows = "nixpkgs";

	# agl-anonymizer.url = "./services/agl-anonymizer";
	# agl-anonymizer.inputs.nixpkgs.follows = "nixpkgs";


  };


outputs = { 
self, nixpkgs, nix-index-database,
vscode-server, sops-nix, 

# CUSTOM SERVICES
agl-monitor,
endoreg-client-manager,
agl-home-django,
agl-g-play,
...
}@inputs: #

let
	base-config = {
		system = "x86_64-linux";

		pkgs = import nixpkgs {
			inherit system;
			config = {
				allowUnfree = true;
				cudaSupport = true;
			};
		};

		agl-network-config = {
			domain = "endo-reg.net";
		};

		base-profile-settings = {
			
		};

		# SERVER / CLIENT IP CONFIG
		# TODO MOVE TO agl-network-config
		agl-server-01-ip = "172.16.255.1";
		agl-server-03-ip = "172.16.255.3";
		agl-server-04-ip = "172.16.255.4";

		agl-nas-01-ip = "172.16.255.120";
		agl-nas-02-ip = "172.16.255.121";

		agl-gpu-client-dev-ip = "172.16.255.140";
		agl-gpu-client-02-ip = "172.16.255.142";
		agl-gpu-client-03-ip = "172.16.255.143";
		agl-gpu-client-04-ip = "172.16.255.144";
		agl-gpu-client-05-ip = "172.16.255.145";

		agl-network-config.ips = {
			agl-server-01 = agl-server-01-ip;
			agl-server-03 = agl-server-03-ip;
			agl-server-04 = agl-server-04-ip;
			agl-nas-01 = agl-nas-01-ip;
			agl-nas-02 = agl-nas-02-ip;
			agl-gpu-client-dev = agl-gpu-client-dev-ip;
			agl-gpu-client-02 = agl-gpu-client-02-ip;
			agl-gpu-client-03 = agl-gpu-client-03-ip;
			agl-gpu-client-04 = agl-gpu-client-04-ip;
			agl-gpu-client-05 = agl-gpu-client-05-ip;
		};

		endoreg-client-manager-port = 9100;
		endoreg-client-manager-redis-port = 6379;

		nextcloud-ip = agl-gpu-client-dev-ip;

		synology-drive-ip = agl-nas-02-ip;
		synology-chat-ip = agl-nas-02-ip;
		synology-video-ip = agl-nas-02-ip;

		synology-service-ip = agl-nas-02-ip;
		synology-drive-port = 12313;
		synology-chat-port = 22323;
		synology-video-port = 9946;
		synology-dsm-port = 5545;

		local-monitoring-config = {
			grafana-port = 3010;
			prometheus-port = 3020;
			prometheus-node-exporter-port = 3021;
			loki-port = 3030;
			promtail-port = 3031;
		};

		agl-network-config.services = {
			main_nginx = {
				ip = agl-server-03-ip;
				# port = local-nginx-port; # Default ports
			};
			local_nginx = {
				port = 6644;
			};
			synology-drive = {
				ip = synology-service-ip;
				port = synology-drive-port;
			};
			synology-chat = {
				ip = synology-service-ip;
				port = synology-chat-port;
			};
			synology-video = {
				ip = synology-service-ip;
				port = synology-video-port;
			};
			synology-dsm = {
				ip = synology-service-ip;
				port = synology-dsm-port;
			};

			# Synology public nas (quickconnect: agl-public-nas.quickconnect.to)
			agl-public-nas = {
				ip = agl-nas-01-ip;
				port = 443;
			};

			ldap = {
				ip = agl-nas-02-ip;
				domain = "ldap.endo-reg.net";
				port = 389;
			};

			# different structure
			local-monitoring = local-monitoring-config;

			# EndoReg Home
			agl-home-django = {
				ip = agl-server-04-ip;
				port = 9129;
				path = "/home/agl-admin/agl-home-django";
			};

			agl-monitor = {
				ip = agl-network-config.ips.agl-server-04;
				port = 9243;
				path = "/home/agl-admin/agl-monitor";
				user = "agl-admin";
				group = "pseudo-access";
				redis-port = 6382;
				redis-bind = "127.0.0.1";
				django-debug = false;
				django-settings-module = "agl_monitor.settings";				
			};

			# G-Play
			agl-g-play = {
				bind = "0.0.0.0";
				port = 3000;
				user = "agl-admin";
				group = "pseudo-access";
				working-directory = "/home/agl-admin/agl-g-play";
			};
			

			# EndoReg Local
			endoreg-client-manager = {
				# ip = agl-server-04-ip; localhost
				port = endoreg-client-manager-port;
			};

			# Grafana
			grafana = {
				ip = agl-server-04-ip;
				port = 2342;
				url = "https://grafana.endo-reg.net/";
			};

			# Keycloak Server
			keycloak = {
				ip = agl-server-03-ip;
				port = 8080;
			};

			# NFS FILE SHARE
			nfs-share = {
				ip = agl-nas-02-ip; #
				local-path = "/home/agl-admin/nfs-share";
				mount-path = "/volume1/agl-share";
			};

		};

		agl-gpu-client-dev-network-interface = "wlo1";
		agl-gpu-client-dev-nvidiaBusId = "PCI:1:0:0";
		agl-gpu-client-dev-onboardGraphicBusId = "PCI:0:2:0";

		agl-gpu-client-02-network-interface = "enp4s0";

		# find with: sudo lshw -c display (look for different drivers)
		# Note the two values under "bus info" above, which may differ from laptop to laptop. Our Nvidia Bus ID is 0e:00.0 and our Intel Bus ID is 00:02.0.
		# Watch out for the formatting; convert them from hexadecimal to decimal, remove the padding (leading zeroes), replace the dot with a colon, then add them like this:
		agl-gpu-client-02-nvidiaBusId = "PCI:1:0:0";
		agl-gpu-client-02-onboardGraphicBusId = "PCI:0:2:0";

		agl-gpu-client-03-network-interface = "wlo1";
		agl-gpu-client-03-nvidiaBusId = "PCI:1:0:0";
		agl-gpu-client-03-onboardGraphicBusId = "PCI:0:2:0";

		agl-gpu-client-04-network-interface = "wlo1";
		agl-gpu-client-04-nvidiaBusId = "PCI:1:0:0";
		agl-gpu-client-04-onboardGraphicBusId = "PCI:0:2:0";

		agl-gpu-client-05-network-interface = "wlo1";
		agl-gpu-client-05-nvidiaBusId = "PCI:1:0:0";
		agl-gpu-client-05-onboardGraphicBusId = "PCI:0:2:0";

		nfs-share-all-local-path = "/home/agl-admin/nfs-share";
		nfs-share-all-mount-path = "/volume1/agl-share";

		openvpnConfigPath = "/home/agl-admin/.openvpn";
		openvpnCertPath = "/home/agl-admin/openvpn-cert";


		agl-anonymizer-port = 9123;
		agl-anonymizer-dir = "/home/agl-admin/agl_anonymizer/agl_anonymizer";
		endoreg-client-manager-config = {
			path = "/home/agl-admin/endoreg-client-manager";
			dropoff-dir = "/mnt/hdd-sensitive/DropOff";
			pseudo-dir = "/mnt/hdd-sensitive/Pseudo";
			processed-dir = "/mnt/hdd-sensitive/Process ed";
			django-debug = true;
			django-settings-module = "endoreg_client_manager.settings";
			user = "agl-admin";
			group = "pseudo-access";
			redis-port = endoreg-client-manager-redis-port;
			port = endoreg-client-manager-port;
			agl-anonymizer-port = agl-anonymizer-port;
			agl-anonymizer-dir = agl-anonymizer-dir;
			agl-anonymizer-django-settings-module = "agl_anonymizer.settings";

	};
	endoRegClientManagerPath = "/home/agl-admin/endoreg-client-manager";

	agl-home-django-config = {
		path = agl-network-config.services.agl-home-django.path;
		user = "agl-admin";
		group = "pseudo-access";
		redis-port = 6379;
		ip = agl-network-config.services.agl-home-django.ip;
		port = agl-network-config.services.agl-home-django.port;
		django-debug = false;
		django-settings-module = "endoreg_home.settings_prod";
		allow-unfree = true;
		cuda-support = true;
	};

	hostnames = {
		server-01 = "agl-server-01";
		server-02 = "agl-server-02";
		server-03 = "agl-server-03";
		server-04 = "agl-server-04";
		gpu-client-dev = "agl-gpu-client-dev";
		gpu-client-01 = "agl-gpu-client-01";
		gpu-client-02 = "agl-gpu-client-02";
		gpu-client-03 = "agl-gpu-client-03";
		gpu-client-04 = "agl-gpu-client-04";
		gpu-client-05 = "agl-gpu-client-05";
	};

	system = base-config.system;
	pkgs = import nixpkgs {
		system = system;
		config = {
			allowUnfree = base-config.allow-unfree;
			cudaSupport = base-config.cuda-support;
		};
	};

	agl-network-config = import ./network-configuration/main.nix;

	custom-services = {
		monitor = agl-monitor;
		client-manager = endoreg-client-manager;
		home-django = agl-home-django;
		g-play = agl-g-play;
	};

	extra-modules = {
		sops-nix = sops-nix;
		vsconde-server = vscode-server;
	};

	os-base-args = {
		nixpkgs = nixpkgs;
		pkgs = pkgs;
		base-config = base-config;
		inputs = inputs;
		agl-network-config = agl-network-config;
		hostnames = hostnames;
	};

	# import os configurations
	_os-configurations = import ./os-configs/main.nix (
		{
			os-base-args = os-base-args;
			agl-network-config = agl-network-config;
			extra-modules = extra-modules;
			custom-services = custom-services;
		}
	);
	os-configurations = _os-configurations.os-configs;

  in
	{
		nixosConfigurations = os-configurations;
	
	};
}
