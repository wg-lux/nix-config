{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    autoAddDriverRunpath
    vim
    wget
    pciutils
    home-manager
    sops
    age
    vscode
    ethtool
    screen
    synology-drive-client
    cryptsetup
    nfs-utils
    brightnessctl
    tldr
    powertop
    unixtools.quota
    chromium
    cachix
    # tmux
    # tmuxp
    
    # Implement custom script example
    (import ../../scripts/test-script.nix { inherit pkgs; })
    
    # AGL Scripts
    (import ../../scripts/manage_agl_home_django.nix { inherit pkgs; })
    (import ../../scripts/update-nix.nix { inherit config pkgs; })
    (import ../../scripts/endoreg-client/dev-mode.nix {inherit pkgs;})
  ] ++ (if config.networking.hostName != "agl-server-01" then [ vault ] else []);
}
