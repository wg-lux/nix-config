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


		# agl-anonymizer.url = "./services/agl-anonymizer";
		# agl-anonymizer.inputs.nixpkgs.follows = "nixpkgs";


  };


  outputs = { 
		self, nixpkgs, nix-index-database,
		vscode-server, sops-nix, 
		# CUSTOM SERVICE
		# customService,
		endoreg-client-manager,
		agl-home-django,
		agl-monitor,
		# agl-anonymizer,
		agl-g-play,



		...
		}@inputs: #

	let
		system = "x86_64-linux";

		pkgs = import nixpkgs {
			inherit system;
			config = {
				allowUnfree = true;
				cudaSupport = true;
			};
		};

		agl-network-config = import ./network-configuration/main.nix;
		
		######## TO BE REFACTORED ########
		
	

	

	#######################################################


  in
	{
		nixosConfigurations = {
			agl-server-01 = nixpkgs.lib.nixosSystem {
				specialArgs = { 
					hostname = "agl-server-01";
					inherit inputs system; 
					inherit agl-network-config;
				};
				
				modules = [
					./profiles/main.nix
					sops-nix.nixosModules.sops
					vscode-server.nixosModules.default
					({ config, pkgs, ... }: {
						  services.vscode-server.enable = true;
					})
					agl-monitor.nixosModules.agl-monitor
				];
			};
			agl-server-02 = nixpkgs.lib.nixosSystem {
				specialArgs = { 
					hostname = "agl-server-02";
					inherit inputs system; 
					inherit agl-network-config;
				};
				
				modules = [
					./profiles/main.nix
					sops-nix.nixosModules.sops
					vscode-server.nixosModules.default
					({ config, pkgs, ... }: {
						  services.vscode-server.enable = true;
					})
					agl-monitor.nixosModules.agl-monitor
				];
			};

			agl-server-03 = nixpkgs.lib.nixosSystem {
				specialArgs = { 
					hostname = "agl-server-03";
					inherit inputs system; 
					inherit agl-network-config;
				};

				modules = [
					./profiles/main.nix
					sops-nix.nixosModules.sops
					vscode-server.nixosModules.default
					({ config, pkgs, ... }: {
						services.vscode-server.enable = true;
					})
					agl-monitor.nixosModules.agl-monitor
				];
			};

			agl-server-04 = nixpkgs.lib.nixosSystem {
				specialArgs = {
				hostname = "agl-server-04";
					inherit inputs system; 
					inherit agl-network-config;
				};
				
				modules = [
					./profiles/main.nix
					sops-nix.nixosModules.sops
					vscode-server.nixosModules.default
					({ config, pkgs, ... }: {
						services.vscode-server.enable = true;
					})
					agl-home-django.nixosModules.agl-home-django
					agl-monitor.nixosModules.agl-monitor
				];
			};

			###
			agl-gpu-client-dev = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";

				specialArgs = {
					hostname = "agl-gpu-client-dev";
					inherit inputs system; 
					inherit agl-network-config;
					
				};
				
				modules = [
					./profiles/main.nix
					sops-nix.nixosModules.sops
					vscode-server.nixosModules.default (
						{ config, pkgs, ... }: {
							services.vscode-server.enable = true;
						}
					)
					(
						{ config, pkgs, ... }: {
							environment.systemPackages = with pkgs; [
							];
						}
					)

					endoreg-client-manager.nixosModules.endoreg-client-manager
					endoreg-client-manager.nixosModules.agl-anonymizer
					agl-monitor.nixosModules.agl-monitor
				];
			};

			agl-gpu-client-01 = nixpkgs.lib.nixosSystem {
				specialArgs = {
					hostname = "agl-gpu-client-01";
					inherit inputs system; 
					inherit agl-network-config;
				};
				
				modules = [
					./profiles/main.nix
					sops-nix.nixosModules.sops
					vscode-server.nixosModules.default
					({ config, pkgs, ... }: {
						  services.vscode-server.enable = true;
					})
					agl-monitor.nixosModules.agl-monitor
				];
			};

			agl-gpu-client-02 = nixpkgs.lib.nixosSystem {
				specialArgs = {
					hostname = "agl-gpu-client-02";
					inherit inputs system; 
					inherit agl-network-config;
				};
				
				modules = [
					./profiles/main.nix
					sops-nix.nixosModules.sops
					vscode-server.nixosModules.default
					({ config, pkgs, ... }: {
						  services.vscode-server.enable = true;
					})
					
					endoreg-client-manager.nixosModules.endoreg-client-manager
					endoreg-client-manager.nixosModules.agl-anonymizer
					# agl-monitor.nixosModules.agl-monitor
				];
			};

			agl-gpu-client-03 = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";

				specialArgs = {
					hostname = "agl-gpu-client-03";
					inherit inputs system; 
					inherit agl-network-config;
				};
				
				modules = [
					./profiles/main.nix
					sops-nix.nixosModules.sops
					vscode-server.nixosModules.default (
						{ config, pkgs, ... }: {
							services.vscode-server.enable = true;
						}
					)

					endoreg-client-manager.nixosModules.endoreg-client-manager
					endoreg-client-manager.nixosModules.agl-anonymizer
					agl-g-play.nixosModules.agl-g-play
					agl-monitor.nixosModules.agl-monitor
				];
			};

			agl-gpu-client-04 = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					hostname = "agl-gpu-client-04";
					inherit inputs system; 
					inherit agl-network-config;
				};
				
				modules = [
					./profiles/main.nix
					sops-nix.nixosModules.sops
					vscode-server.nixosModules.default (
						{ config, pkgs, ... }: {
							services.vscode-server.enable = true;
						}
					)
					
					endoreg-client-manager.nixosModules.endoreg-client-manager
					endoreg-client-manager.nixosModules.agl-anonymizer
					agl-monitor.nixosModules.agl-monitor
				];
			};

			agl-gpu-client-05 = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					hostname = "agl-gpu-client-05";
					inherit inputs system; 
					inherit agl-network-config;
				};
				
				modules = [
					./profiles/main.nix

					sops-nix.nixosModules.sops
					vscode-server.nixosModules.default (
						{ config, pkgs, ... }: {
							services.vscode-server.enable = true;
						}
					)
					
					endoreg-client-manager.nixosModules.endoreg-client-manager
					endoreg-client-manager.nixosModules.agl-anonymizer
					agl-monitor.nixosModules.agl-monitor
				];
			};
		};
	
	};
}
