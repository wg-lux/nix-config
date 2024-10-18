# let
#   # Trace the path to ensure it’s correct
# 	hostnames = builtins.trace "Importing hostnames from: ./hostnames.nix" (import ./hostnames.nix);

# 	configs = {
# 		"${hostnames.gpu-client-dev}" = import ../config/${hostnames.gpu-client-dev}/hardware.nix;
# 		"${hostnames.gpu-client-01}" = import ../config/${hostnames.gpu-client-01}/hardware.nix;
# 		"${hostnames.gpu-client-02}" = import ../config/${hostnames.gpu-client-02}/hardware.nix;
# 		"${hostnames.gpu-client-03}" = import ../config/${hostnames.gpu-client-03}/hardware.nix;
# 		"${hostnames.gpu-client-04}" = import ../config/${hostnames.gpu-client-04}/hardware.nix;
# 		"${hostnames.gpu-client-05}" = import ../config/${hostnames.gpu-client-05}/hardware.nix;
# 		"${hostnames.server-01}" = import ../config/${hostnames.server-01}/hardware.nix;
# 		"${hostnames.server-02}" = import ../config/${hostnames.server-02}/hardware.nix;
# 		"${hostnames.server-03}" = import ../config/${hostnames.server-03}/hardware.nix;
# 		"${hostnames.server-04}" = import ../config/${hostnames.server-04}/hardware.nix;
# 	};


# in configs
