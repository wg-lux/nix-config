# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ 
    "xhci_pci"
    "ahci" "nvme" "usbhid" "usb_storage"
    "sd_mod" 
    ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.extraModprobeConfig = ''
  '';


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c8fdc2af-c01c-4237-9f58-91f7ad7acf50";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-274d2191-1443-41f9-bee5-0efc0fc705bf".device = "/dev/disk/by-uuid/274d2191-1443-41f9-bee5-0efc0fc705bf";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9675-A87D";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d321d297-a334-4a1a-a77b-00b2974f4358"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
