{ 
  agl-network-config,
  ... 
}: 
let
  admin-user = agl-network-config.users.admin-user;
in
{

  security.sudo.wheelNeedsPassword = false;


# ###################
# FOR FUTURE USE
# # Allow execution of any command by all users in group sudo,
#   # requiring a password.
#   { groups = [ "sudo" ]; commands = [ "ALL" ]; }

#   # Allow execution of "/home/root/secret.sh" by user `backup`, `database`
#   # and the group with GID `1006` without a password.
#   { users = [ "backup" "database" ]; groups = [ 1006 ];
#     commands = [ { command = "/home/root/secret.sh"; options = [ "SETENV" "NOPASSWD" ]; } ]; }

#   # Allow all users of group `bar` to run two executables as user `foo`
#   # with arguments being pre-set.
#   { groups = [ "bar" ]; runAs = "foo";
#     commands =
#       [ "/home/baz/cmd1.sh hello-sudo"
#           { command = ''/home/baz/cmd2.sh ""''; options = [ "SETENV" ]; } ]; }

######################

  # security.polkit.extraConfig = ''
  #   // Allow the admin user to run `nix-collect-garbage -d`
  #   polkit.addRule(function(action, subject) {
  #     if (
  #       action.id == "org.nixos.nix.collect-garbage" &&
  #       subject.name == "${admin-user}"
  #     ) {
  #       return polkit.Result.YES;
  #     }
  #   });

  #   // Allow the admin user to run `nixos-rebuild switch --flake`
  #   polkit.addRule(function(action, subject) {
  #     if (
  #       action.id == "org.nixos.nixos.rebuild" &&
  #       action.lookup("arguments").indexOf("--flake") >= 0 &&
  #       action.lookup("arguments").indexOf("/home/${admin-user}/nix-config") >= 0 &&
  #       subject.name == "${admin-user}"
  #     ) {
  #       return polkit.Result.YES;
  #     }
  #   });

  #   // Allow the admin user to use sudo for nixos-rebuild switch
  #   polkit.addRule(function(action, subject) {
  #     if (
  #       action.id == "org.freedesktop.policykit.exec" &&
  #       action.lookup("arguments").indexOf("/run/current-system/sw/bin/sudo") >= 0 &&
  #       action.lookup("arguments").indexOf("nixos-rebuild") >= 0 &&
  #       subject.name == "${admin-user}"
  #     ) {
  #       return polkit.Result.YES;
  #     }
  #   });
  # '';
}
