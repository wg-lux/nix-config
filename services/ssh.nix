{ config, pkgs, ... }: {
  
  environment.systemPackages = [
    # (import ../scripts/base-ssh-add.nix {inherit config pkgs;})
  ];

  # Enable the OpenSSH daemon
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  # Optional: Configure additional settings
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = true;
    # PasswordAuthentication = false;
    port = 22;  # You can change the SSH port here
    # Additional configurations can be added here
  };

# User configuration,
  users.users.agl-admin.openssh.authorizedKeys = {
    keys = [
      # lux-root
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/gVfFAeG/9CwqiPOxu5JoY/vx705a77wvGgh687a5d" 
      # agl-gc-dev
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwYnbv/tPCcTIPgFbOISXDOiGZGpyUtu6NmtJ+Pg9Dh agl-gpu-client-dev"
    ];
  };

  ###### SSH AGENT SCRIPT LOCATED in users/agl-admin/files/base.nix

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

}
