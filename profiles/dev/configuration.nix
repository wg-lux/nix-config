# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, system, ... }:
let
  hostname = "dev";
  network_interface = "wlp0s20f3"; # is wifi ; enp44s0 is ethernet

  nvidiaBusId = "PCI:1:0:0";
  intelBusId = "PCI:0:2:0";

in  
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users.nix
      ./packages.nix
      (import ../shared/nvidia.nix { inherit config pkgs nvidiaBusId intelBusId; })
      # ./wireguard.nix
      ( import ../base/configuration.nix { inherit config pkgs inputs network_interface; })
      # ../../services/grafana.nix
    ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # Set your desktop environment, in this case, i3
  services.xserver.windowManager.i3.enable = true;

    # UI  # Enable dark mode for GTK and Qt applications
  # services.xserver.displayManager.lightdm = {
  #   enable = true;
  #   greeters = {
  #     gtk = {
  #       enable = true;
  #       theme.name = "Adwaita";
  #       iconTheme.name = "Adwaita";
  #     };
  #   };
  # };

  system.stateVersion = "23.11";

}
