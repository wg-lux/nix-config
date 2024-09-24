let
  # Trace the path to ensure it’s correct
	hostnames = builtins.trace "Importing hostnames from: ./hostnames.nix" (import ./hostnames.nix);

	configs = {
		"${hostnames.gpu-client-dev}" = import ../config/${hostnames.gpu-client-dev}/hardware.nix;
		"${hostnames.gpu-client-01}" = import ../config/${hostnames.gpu-client-01}/hardware.nix;
		"${hostnames.gpu-client-02}" = import ../config/${hostnames.gpu-client-02}/hardware.nix;
		"${hostnames.gpu-client-03}" = import ../config/${hostnames.gpu-client-03}/hardware.nix;
		"${hostnames.gpu-client-04}" = import ../config/${hostnames.gpu-client-04}/hardware.nix;
		"${hostnames.gpu-client-05}" = import ../config/${hostnames.gpu-client-05}/hardware.nix;
		"${hostnames.server-01}" = import ../config/${hostnames.server-01}/hardware.nix;
		"${hostnames.server-02}" = import ../config/${hostnames.server-02}/hardware.nix;
		"${hostnames.server-03}" = import ../config/${hostnames.server-03}/hardware.nix;
		"${hostnames.server-04}" = import ../config/${hostnames.server-04}/hardware.nix;
	};


in configs


#  {
# 		"${hostnames.gpu-client-dev}" = (builtins.fromJSON (builtins.readFile filePath));
# 		# "${hostnames.gpu-client-01}" = loadConfig hostnames.gpu-client-01;
# 		# "${hostnames.gpu-client-02}" = loadConfig hostnames.gpu-client-02;
# 		# "${hostnames.gpu-client-03}" = loadConfig hostnames.gpu-client-03;
# 		# "${hostnames.gpu-client-04}" = loadConfig hostnames.gpu-client-04;
# 		# "${hostnames.gpu-client-05}" = loadConfig hostnames.gpu-client-05;
# 		# "${hostnames.server-01}" = loadConfig hostnames.server-01;
# 		# "${hostnames.server-02}" = loadConfig hostnames.server-02;
# 		# "${hostnames.server-03}" = loadConfig hostnames.server-03;
# 		# "${hostnames.server-04}" = loadConfig hostnames.server-04;
# 	}

# {
# 		# test = generatedConfigs;

# 		# find with nvidia bus id: sudo lshw -c display (look for different drivers)
# 		# Note the two values under "bus info" above, which may differ from laptop to laptop. Our Nvidia Bus ID is 0e:00.0 and our Intel Bus ID is 00:02.0.
# 		# Watch out for the formatting; convert them from hexadecimal to decimal, remove the padding (leading zeroes), replace the dot with a colon, then add them like this:

# 		"${hostnames.gpu-client-dev}" = ;


# 		"${hostnames.gpu-client-02}" = 

# 		"${hostnames.gpu-client-03}"  = ;

# 		"${hostnames.gpu-client-04}"  =;

# 		"${hostnames.gpu-client-05}"  = ;


# 		"${hostnames.server-01}"  = ;

# 		"${hostnames.server-02}" = ;

# 		"${hostnames.server-03}" = ;

# 		"${hostnames.server-04}" = ;	
# }