{ config, pkgs, ... }: {
users.users.agl-admin.openssh.authorizedKeys = {
    keys = [
        #agl-gc3
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM87xeXKvfTTfcVbL+pKorYMCnFRdIyvAgFZsZqqh3Ou eddsa-key-hild-laptop"
    ];
  };
}