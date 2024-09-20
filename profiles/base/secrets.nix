{ config, ... }:

let
  hostname = config.networking.hostName;
  secret-path-users = ../../secrets + ("/" + "${hostname}/user.yaml");
  secret-path-id_ed25519 = ../../secrets + ("/" + "${hostname}/id_ed25519.yaml");

in
{

    sops.secrets."identity/id_ed25519" = {
        sopsFile = secret-path-id_ed25519;
        path = "/home/agl-admin/.ssh/id_ed25519";
        format = "yaml";
        owner = "agl-admin";
    };

    sops.secrets."user/nix/root/pwd" = {
        sopsFile = secret-path-users;
        neededForUsers=true;
        mode = "700";
    };

    sops.secrets."user/nix/agl-admin/pwd" = {
        sopsFile = secret-path-users;
        neededForUsers=true;
        mode = "700";
    };

    sops.secrets."user/nix/default-user/pwd" = {
      sopsFile = secret-path-users;
      neededForUsers = true;
      mode = "700";
    };

    sops.secrets."user/nix/center-user/pwd" = {
      sopsFile = secret-path-users;
      neededForUsers = true;
      mode = "700";
    };#

    sops.secrets."user/nix/maintenance-user/pwd" = {
      sopsFile = secret-path-users;
      neededForUsers = true;
      mode = "700";
    };

    sops.secrets."user/nix/service-user/pwd" = {
      sopsFile = secret-path-users;
      neededForUsers = true;
      mode = "700";
    };

    
    
}