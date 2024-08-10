{ 
  config, pkgs, 
  agl-network-config,
  ...}: 

let 

  endoreg-home-port = agl-network-config.services.endoreg-home.port;
  endoreg-home-path = agl-network-config.services.endoreg-home.path;
  endoreg-home-ip = agl-network-config.services.endoreg-home.ip;
  endoreg-home-bind-address = "${endoreg-home-ip}:${toString endoreg-home-port}";

  hostname = config.networking.hostName;

  agl-home-django-secret-path = ../secrets + ("/" +"${hostname}" + "/services/agl-home-django.yaml");

in
    {

    # Will only worked after the first build & executing the following script: "manage_agl_home_django"
    
    sops.secrets."services/agl-home-django/secret-key" = {
      sopsFile = agl-home-django-secret-path;
      path = "${endoreg-home-path}/.env/secret";
      format = "yaml";
      owner = config.users.users.agl-admin.name;
    };

    sops.secrets."services/agl-home-django/keycloak-client-id" = {
      sopsFile = agl-home-django-secret-path;
      path = "${endoreg-home-path}/.env/keycloak-client";
      format = "yaml";
      owner = config.users.users.agl-admin.name;
    };

    sops.secrets."services/agl-home-django/keycloak-secret" = {
      sopsFile = agl-home-django-secret-path;
      path = "${endoreg-home-path}/.env/keycloak-secret";
      format = "yaml";
      owner = config.users.users.agl-admin.name;
    };

    # make firewall rules
    networking.firewall.allowedTCPPorts = [ endoreg-home-port ];


    systemd.services.agl-home-django = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    script = ''
      # Activate the Python virtual environment
      # source ${endoreg-home-path}/.venv/bin/activate
      nix develop
      
      # Set the Django settings module environment variable
      export DJANGO_SETTINGS_MODULE=endoreg_home.settings_prod
      export DJANGO_SECRET_KEY=$(cat ${endoreg-home-path}/.env/secret)
      export KEYCLOAK_CLIENT=$(cat ${endoreg-home-path}/.env/keycloak-client)
      export KEYCLOAK_SECRET=$(cat ${endoreg-home-path}/.env/keycloak-secret)
      
      # Start the Gunicorn server to serve the Django application
      exec gunicorn endoreg_home.wsgi:application --bind ${endoreg-home-bind-address}
    '';
    serviceConfig = {
      Restart = "always";
      User = "agl-admin"; # Replace with the user you want the service to run as
      # Group = "agl-admin"; # Replace with the group you want the service to run as
      # It's important to set the working directory to where your Django project is
      WorkingDirectory = "${endoreg-home-path}/endoreg_home";
      Environment = [
                "PATH=${endoreg-home-path}/.venv/bin:/run/current-system/sw/bin"
                "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
                "DJANGO_SETTINGS_MODULE=endoreg_home.settings_prod"
              ];
      # Add environment variables if necessary
      # Environment = [
      #   "PATH=/run/current-system/sw/bin:$PATH"
      # ];
    };
  };
}


# export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
#                 pkgs.stdenv.cc.cc
#                 pkgs.ncurses5
#                 pkgs.gcc
#       ]}
