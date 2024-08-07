{config, pkgs, nvidiaBusId, onboardGraphicBusId, ...}: 

{
  # hardware.graphics = { # temporarily changed for backwardscompatibility for unstable to stable 24.05
  hardware.opengl = {
    enable = true;
  };

  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  boot.initrd.kernelModules = [ "nvidia" ];

  nixpkgs.config.cudaSupport = true;
  
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [
    "nvidia"
    ];

  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
    linuxPackages.nvidia_x11

    autoAddDriverRunpath
    
    git gitRepo gnupg autoconf curl
    procps gnumake util-linux m4 gperf unzip

    libGLU libGL
    glibc
    xorg.libXi xorg.libXmu freeglut
    xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib 
    ncurses5 stdenv.cc binutils

  ];


  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    sync.enable = true; 
		# Make sure to use the correct Bus ID values for your system!
		intelBusId = onboardGraphicBusId;
		nvidiaBusId = nvidiaBusId;
	};


}
