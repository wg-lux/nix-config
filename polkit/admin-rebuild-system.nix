{ 
  agl-network-config,
  ... 
}: 
let
  admin-user = agl-network-config.users.admin-user;
in
{
  security.polkit.extraConfig = ''
    // Allow the admin user to run `nix-collect-garbage -d`
    polkit.addRule(function(action, subject) {
      if (
        action.id == "org.nixos.nix.collect-garbage" &&
        subject.name == "${admin-user}"
      ) {
        return polkit.Result.YES;
      }
    });

    // Allow the admin user to run `nixos-rebuild switch --flake`
    polkit.addRule(function(action, subject) {
      if (
        action.id == "org.nixos.nixos.rebuild" &&
        action.lookup("arguments").indexOf("--flake") >= 0 &&
        action.lookup("arguments").indexOf("/home/${admin-user}/nix-config") >= 0 &&
        subject.name == "${admin-user}"
      ) {
        return polkit.Result.YES;
      }
    });
  '';
}
