{
		# find with nvidia bus id: sudo lshw -c display (look for different drivers)
		# Note the two values under "bus info" above, which may differ from laptop to laptop. Our Nvidia Bus ID is 0e:00.0 and our Intel Bus ID is 00:02.0.
		# Watch out for the formatting; convert them from hexadecimal to decimal, remove the padding (leading zeroes), replace the dot with a colon, then add them like this:

		agl-gpu-client-dev = {
			network-interface = "wlo1";
			secondary-network-interface = "";
			nvidiaBusId = "PCI:1:0:0";
			onboardGraphicBusId = "PCI:0:2:0";

			file-system-base-uuid = "57583232-d300-40d8-ae04-3ae510697a13";
			file-system-boot-uuid = "739A-7657";
			swap-device-uuid = "8c497dfb-c2ae-46d1-9314-305dddd50620";

			luks-hdd-intern-uuid = "2d8b5a20-2780-43b6-a0f8-e26bd36d19e6";
			luks-swap-uuid = "4da269f8-08c4-4f1d-9fb3-dfd440c4bd32";
		};

		agl-gpu-client-01 = {
			network-interface = "enp5s0"; # is ethernet ;
			secondary-network-interface = "wlp2s0";
			nvidiaBusId = "PCI:1:0:0";
			onboardGraphicBusId = "PCI:0:2:0";

			file-system-base-uuid = "de64005e-a271-4965-bef2-7372f1992740";
			file-system-boot-uuid = "AD97-3B62";
			swap-device-uuid = "";

			luks-hdd-intern-uuid = "c92e0580-5f9a-4e2f-918b-4e8270e3428f";
			luks-swap-uuid = "";
		};

		agl-gpu-client-02 = {
			network-interface = "enp4s0"; #TODO Check if this is correct
			secondary-network-interface = "";
			nvidiaBusId = "PCI:1:0:0";
			onboardGraphicBusId = "PCI:0:2:0";

			file-system-base-uuid = "9b443144-d740-49d9-b72b-c11d4dcf8d72";
			file-system-boot-uuid = "46D6-EB19";
			swap-device-uuid = "";

			luks-hdd-intern-uuid = "01af2a76-aa8a-46f1-aa8b-8b4bc614cb0e";
			luks-swap-uuid = "";
		};

		agl-gpu-client-03 = {
			network-interface = "wlo1";
			secondary-network-interface = "";
			nvidiaBusId = "PCI:1:0:0";
			onboardGraphicBusId = "PCI:0:2:0";

			file-system-base-uuid = "eb8c2a80-3615-492e-9426-5a0867d1719b";
			file-system-boot-uuid = "0BBB-8DA2";
			swap-device-uuid = "99942727-d084-4612-bc32-378f3cfce48d";

			luks-hdd-intern-uuid = "4052a436-8b52-4969-adc0-f0e985fe6b6d";
			luks-swap-uuid = "8d58f4dd-cfb1-4360-8410-60d1dad60741";
		};

		agl-gpu-client-04 = {
			network-interface = "wlo1";
			secondary-network-interface = "";
			nvidiaBusId = "PCI:1:0:0";
			onboardGraphicBusId = "PCI:0:2:0";

			file-system-base-uuid = "a0bd942b-f872-413e-af27-937ecba187c2";
			file-system-boot-uuid = "4C7A-7E5C";
			swap-device-uuid = "64cc1caf-89ca-443f-88a9-05d10cd3a221";

			luks-hdd-intern-uuid = "d6f45719-99f8-4147-b9c6-6d5e8583b702";
			luks-swap-uuid = "447d17e7-c451-4d1c-8731-9e42feaf5d24";
		};

		agl-gpu-client-05 = {
			network-interface = "wlo1";
			secondary-network-interface = "";
			nvidiaBusId = "PCI:1:0:0";
			onboardGraphicBusId = "PCI:0:2:0";

			file-system-base-uuid = "c8fdc2af-c01c-4237-9f58-91f7ad7acf50";
			file-system-boot-uuid = "9675-A87D";
			swap-device-uuid = "d321d297-a334-4a1a-a77b-00b2974f4358";

			luks-hdd-intern-uuid = "274d2191-1443-41f9-bee5-0efc0fc705bf";
			luks-swap-uuid = "6e991f24-1dbb-4bd8-a91c-849b887a0f6e";
		};


		agl-server-01 = {
			network-interface = "enp1s0";
			secondary-network-interface = "";
			nvidiaBusId = "";
			onboardGraphicBusId = "";
		};

		agl-server-02 = {
			network-interface = "enp4s0";
			secondary-network-interface = "eno1";
			wireless-network-interface = "";
			nvidiaBusId = "";
			onboardGraphicBusId = "";

			file-system-base-uuid = "fc03f392-8ec1-4370-9dfa-915acc831d78";
			file-system-boot-uuid = "6A18-8054";
			swap-device-uuid = "ea43412b-f591-48c3-b2b2-7cdd6cb10f8b";
		};

		agl-server-03 = {
			network-interface = "enp2s0";
			secondary-network-interface = "";
			nvidiaBusId = "";
			onboardGraphicBusId = "";
		};

		agl-server-04 = {
			network-interface = "eno1";
			secondary-network-interface = "";
			nvidiaBusId = "";
			onboardGraphicBusId = "";
		};

		

		
}