{pkgs, ...}: {

  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;    ## If compatibility with 32-bit applications is desired.
  # hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;  # Ensures full feature set
    extraConfig = ''
      load-module module-alsa-card
      load-module module-udev-detect
    '';
  };

  
  # Ensure all necessary firmware and drivers are available
  hardware.enableAllFirmware = true;
  # sound.enable = true;

  # Enable realtime kit for realtime priority for audio processes
  # security.rtkit.enable = true;
  # services.pulseaudio.enable = false;  
  # # Configure PipeWire with compatibility for both ALSA and PulseAudio
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;  # This makes PipeWire act as a drop-in replacement for PulseAudio
  #   # Uncomment below if using JACK applications
  #   jack.enable = false;
  # };

  # # Ensure the user session can start correctly
  # services.dbus.packages = with pkgs; [
  #   pipewire
  # ];

#   services.pipewire.extraConfig.pipewire."92-low-latency" = {
#   context.properties = {
#     default.clock.rate = 48000;
#     default.clock.quantum = 32;
#     default.clock.min-quantum = 32;
#     default.clock.max-quantum = 32;
#   };
# };



  # Enable sound with pipewire.
  # sound.enable = true;

  # # add pulseaudio to system packages
  environment.systemPackages = with pkgs; [
    # libsForQt5.plasma-pa
  ];

  # security.rtkit.enable = true;
  # # services.pulseaudio = {
  # #   enable = true;
  # #   # alsa.enable = true;
  # #   # alsa.support32Bit = true;
  # #   # pulse.enable = true;
  # #   # jack.enable = true;
  # # };
  # # services.pipewire = {
  # #   enable = true;
  # #   # audio.enable = true;
  # #   alsa.enable = true;
  # #   alsa.support32Bit = true;
  # #   pulse.enable = true;
  # #   # jack.enable = true;
  # #   wireplumber.enable = true;
  # # };
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.package = pkgs.pulseaudioFull;
  # hardware.pulseaudio.support32Bit = true;
  # nixpkgs.config.pulseaudio = true;
  # services.jack = {
  #   jackd.enable = true;
  #   # support ALSA only programs via ALSA JACK PCM plugin
  #   alsa.enable = false;
  #   # support ALSA only programs via loopback device (supports programs like Steam)
  #   loopback = {
  #     enable = true;
  #     # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
  #     #dmixConfig = ''
  #     #  period_size 2048
  #     #'';
  #   };
  # };
  # users.extraUsers.agl-admin.extraGroups = [ "jackaudio" ];


}