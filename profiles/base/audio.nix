{pkgs, ...}: {

  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;    ## If compatibility with 32-bit applications is desired.

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  services.pipewire.extraConfig.pipewire."92-low-latency" = {
  context.properties = {
    default.clock.rate = 48000;
    default.clock.quantum = 32;
    default.clock.min-quantum = 32;
    default.clock.max-quantum = 32;
  };
};



  # Enable sound with pipewire.
  # sound.enable = true;

  # # add pulseaudio to system packages
  environment.systemPackages = with pkgs; [
    # plasma-pa
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