{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  
  services.gnome.core-utilities.enable = true;
  # services.gnome.gnome-remote-desktop.enable = true;
  
  # Using the following example configuration, QT applications 
  # will have a look similar to the GNOME desktop, using a dark theme
  # qt = {
  #   enable = true;
  #   platformTheme = "kde";
  #   style = "bb10dark";
  # };


  environment.systemPackages = with pkgs; [
    ## KDE Plasma Desktop
    # plasma-hud
    # plasma-theme-switcher

    # # kdePackages.sddm-kcm
    # kdePackages.kdenlive
    # kdePackages.wrapQtAppsHook
    kdePackages.xdg-desktop-portal-kde
    kdePackages.svgpart
    # kdePackages.zanshin
    # # kdePackages.umbrello
    # kdePackages.taglib
    kdePackages.systemsettings
    # kdePackages.sweeper
    # kdePackages.sddm
    # kdePackages.kdeconnect-kde
    kdePackages.zanshin # getting things done app
  ];

  # programs.xwayland.enable = true;
  # programs.hyprland.enable = true;

  programs.ssh.askPassword = pkgs.lib.mkForce "yes";
  services.desktopManager.plasma6.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "de";
    xkb.variant = "";
    displayManager = {
      defaultSession = "plasmax11";
      sddm = {
        enable = true;
        # wayland.enable = true;

      };
      gdm= {
        enable = false;
        autoSuspend = false;
        autoLogin.delay = 15;
      };
          # gdm.autoSuspend = false;
          # gdm.autoLogin.delay = 15; 
          # defaultSession = "gnome";
          # autoLogin = {
          #     enable = true;
          #     user = "default-user";
          # };

    };
  };
}