# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib,
  openvpnCertPath,
  agl-home-django-package, #TODO CHECK IF STILL NEEDED
  endoRegClientManagerPath, 
  
  ... }:
let
  hostname = "agl-gpu-client-01";
  network_interface = "enp5s0"; # is ethernet ; wlp2s0 is wlan
  

  # find with: sudo lshw -c display (look for different drivers)
  # Note the two values under "bus info" above, which may differ from laptop to laptop. Our Nvidia Bus ID is 0e:00.0 and our Intel Bus ID is 00:02.0. 
  # Watch out for the formatting; convert them from hexadecimal to decimal, remove the padding (leading zeroes), replace the dot with a colon, then add them like this: 
  nvidiaBusId = "PCI:1:0:0";
  onboardGraphicBusId = "PCI:0:2:0";

in  
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ( import ./packages.nix { inherit pkgs ; })
      (import ../endoreg-clients/secrets.nix {inherit config pkgs endoRegClientManagerPath hostname ;} )
      (import ../shared/nvidia.nix { inherit config pkgs nvidiaBusId onboardGraphicBusId; })
      (import ../shared/obsidian.nix { inherit pkgs ; })
      (import ../shared/ffmpeg.nix { inherit pkgs ; })
      (import ../shared/opencv.nix { inherit pkgs ; })
      (import ../shared/docker.nix { inherit pkgs ; })
      # ./wireguard.nix
      ( import ../base/configuration.nix { inherit config pkgs lib inputs network_interface; 
        inherit hostname; 
        inherit openvpnCertPath;
        })
      (import ../shared/python/main.nix { inherit pkgs; })


      # Custom Services
      (import ../../services/endoreg-client/client_manager_celery.nix { inherit config pkgs lib endoRegClientManagerPath; })
      (import ../../services/endoreg-client/client_manager_django.nix { inherit config pkgs endoRegClientManagerPath; })
      # (import ../../services/endoreg-client/client_manager_flower.nix { inherit config pkgs endoRegClientManagerPath; })
      # (import ../../services/endoreg-client/mount-processed.nix { inherit config lib pkgs; })
      
      ( import ../../scripts/endoreg-client/data-mount-dropoff.nix {inherit pkgs config lib hostname;})
      ( import ../../scripts/endoreg-client/data-mount-processed.nix {inherit pkgs config lib hostname;})
      ( import ../../scripts/endoreg-client/data-mount-pseudo.nix {inherit pkgs config lib hostname;})
    
      ( import ../../scripts/endoreg-client/data-umount-dropoff.nix {inherit pkgs config lib hostname;})
      ( import ../../scripts/endoreg-client/data-umount-pseudo.nix {inherit pkgs config lib hostname;})
      ( import ../../scripts/endoreg-client/data-umount-processed.nix {inherit pkgs config lib hostname;}) 


    ];


  security.polkit.enable = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  hardware.acpilight.enable = true;

  system.stateVersion = "23.11";

}
