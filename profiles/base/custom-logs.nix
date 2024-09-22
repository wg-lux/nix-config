{
   config, pkgs, lib, agl-network-config,
   ...
}:

{
    imports = [
        (
            import ../../scripts/logging/setup-custom-log-dir.nix {
                inherit config pkgs lib agl-network-config;
            }
        )

        (
            import ../../scripts/logging/check-openvpn.nix {
                inherit config pkgs lib agl-network-config;
            }
        )

        (
            import ../../scripts/logging/clear-custom-logs.nix {
                inherit config pkgs lib agl-network-config;
            }
        )
    ];
}