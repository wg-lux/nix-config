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
		extra-modules = extra-modules;
		custom-services = custom-services;
		hostnames = hostnames;
	};

	_os-configurations = import ./os-configs/main.nix (
		{
			os-base-args = os-base-args;
			agl-network-config = agl-network-config;
			extra-modules = extra-modules;
			custom-services = custom-services;
		}
	);
	os-configurations = _os-configurations.os-configs;
  
in {
		nixosConfigurations = os-configurations;
	};
}
