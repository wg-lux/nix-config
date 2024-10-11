{
    os-base-args,
    extra-modules, custom-services,
    ...
}@args:

let 

    hostnames = os-base-args.hostnames;
    agl-network-config = os-base-args.agl-network-config;
	custom-packages = args.custom-packages;

    os-configs = {
		"${hostnames.server-01}" = import ./base-server.nix (
			os-base-args // {
				hostname = hostnames.server-01;
				extra-modules = extra-modules;
				custom-services = custom-services;
			}
		);
		"${hostnames.server-02}" = import ./base-server.nix (
			os-base-args // {
				hostname = hostnames.server-02;
				extra-modules = extra-modules;
				custom-services = custom-services;
			}
		);
		"${hostnames.server-03}" = import ./base-server.nix (
			os-base-args // {
				hostname = hostnames.server-03;
				extra-modules = extra-modules;
				custom-services = custom-services;
			}
		);
		"${hostnames.server-04}" = import ./base-server.nix (
			os-base-args // {
				hostname = hostnames.server-04;
				extra-modules = extra-modules;
				custom-services = custom-services;
			}
		);
		"${hostnames.gpu-client-dev}" = import ./gpu-client-dev.nix (
			os-base-args // {
				hostname = hostnames.gpu-client-dev;
				extra-modules = extra-modules;
				custom-services = custom-services;
				custom-packages = custom-packages;
			}
		);
		"${hostnames.gpu-client-01}" = import ./endoreg-gpu-client.nix (
			os-base-args // {
				hostname = hostnames.gpu-client-01;
				extra-modules = extra-modules;
				custom-services = custom-services;
			}
		);
		"${hostnames.gpu-client-02}" = import ./endoreg-gpu-client.nix (
			os-base-args // {
				hostname = hostnames.gpu-client-02;
				extra-modules = extra-modules;
				custom-services = custom-services;
			}
		);
		"${hostnames.gpu-client-03}" = import ./gpu-client-dev.nix (
			os-base-args // {
				hostname = hostnames.gpu-client-03;
				extra-modules = extra-modules;
				custom-services = custom-services;
			}
		);
		"${hostnames.gpu-client-04}" = import ./endoreg-gpu-client.nix (
			os-base-args // {
				hostname = hostnames.gpu-client-04;
				extra-modules = extra-modules;
				custom-services = custom-services;
			}
		);
		"${hostnames.gpu-client-05}" = import ./endoreg-gpu-client.nix (
			os-base-args // {
				hostname = hostnames.gpu-client-05;
				extra-modules = extra-modules;
				custom-services = custom-services;
			}
		);
		
	};

in {
    os-configs = os-configs;
}