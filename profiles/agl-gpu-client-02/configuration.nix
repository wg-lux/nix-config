{ inputs, config, pkgs, lib,
  custom-hardware-config, ip, hostname, agl-network-config,
  ... 
}: 
{
  imports =
    [ 
      (
        import ../endoreg-clients/base.nix {
          inherit config pkgs lib;
          inherit custom-hardware-config ip hostname agl-network-config;
        }
      )
    ];

  hardware.acpilight.enable = true;

  system.stateVersion = "23.11";

}
