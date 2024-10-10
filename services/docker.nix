{ config, pkgs, ... }:

{
  # Enable the Docker service
  virtualisation.docker.enable = true;

  # Add your user to the docker group
  users.users.anonymizer.extraGroups = [ "docker" ];  # Replace 'anonymizer' with your actual username

  # Optional: Enable Docker rootless mode
  # virtualisation.docker.rootless.enable = true;
  # virtualisation.docker.rootless.setSocketVariable = true;

  # Configure Docker's storage driver if necessary
  # virtualisation.docker.storageDriver = "btrfs";  # Uncomment if using btrfs filesystem

  # Additional optional settings, for example, Docker daemon settings
  virtualisation.docker.daemon.settings = {
    experimental = true;
    metrics-addr = "0.0.0.0:9323";
    ipv6 = true;
    fixed-cidr-v6 = "fd00::/80";
  };

  # If you need to define Docker containers as systemd services, you can use `oci-containers`
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      my-container = {
        image = "agl-anonymizer";
        ports = [ "8000:8000" ];
        environment = {
          "DJANGO_DEBUG" = "false";
          "AGL_ANONYMIZER_TMP_DIR" = "/var/anonymizer/tmp";
        };
      };
    };
  };
}
