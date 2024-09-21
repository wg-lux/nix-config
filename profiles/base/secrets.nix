{ config, ... }:

let
  hostname = config.networking.hostName;
  secret-path-users = ../../secrets + ("/" + "${hostname}/user.yaml");

in
{

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