{ pkgs, ... }: {

  virtualisation.docker.enable = true;

  users.extraGroups.docker.members = [ "agl-admin" ];

  # alternatively add users one by one
  # users.users.<myuser>.extraGroups = [ "docker" ];


  # Define docker containers as services:
  # virtualisation.oci-containers = {
  #   backend = "docker";
  #   containers = {
  #     foo = {
  #       # ...
  #     };
  #   };
  # };


}
