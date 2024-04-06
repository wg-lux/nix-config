{ 
  config, pkgs,
  endoreg-client-manager-config,
  ...}: 

let 

  # Get attributes from the configuration
  endoreg-client-manager-path = endoreg-client-manager-config.path;
  DROPOFF_DIR = endoreg-client-manager-config.dropoff-dir;
  PSEUDO_DIR = endoreg-client-manager-config.pseudo-dir;
  PROCESSED_DIR = endoreg-client-manager-config.processed-dir;
  DJANGO_DEBUG = endoreg-client-manager-config.django-debug;
  user = endoreg-client-manager-config.user;
  group = endoreg-client-manager-config.group;
  port = endoreg-client-manager-config.port;
  custom-config-path = ../../config + ("/${config.networking.hostName}");

  client-manager-config-path = custom-config-path + ("/client-manager-config.json");

in
  {

    
    systemd.services.endoreg-client-manager = {
    after = [ 
      "network.target" 
      "redis-endoreg-client-manager.service" 
    ];
    requires = [ 
      "redis-endoreg-client-manager.service" 
    ];
    wantedBy = [ "multi-user.target" ];

    script = ''
      # Activate the Python virtual environment
      export CUDA_PATH=${pkgs.cudatoolkit}
      export CUDA_HOME=${pkgs.cudatoolkit}
      export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib
      
      nix develop
      
      export DJANGO_SECRET_KEY=$(cat ${endoreg-client-manager-path}/.env/secret)

      exec gunicorn endoreg_client_manager.wsgi:application --bind 0.0.0.0:${toString port}      
    '';
    serviceConfig = {
      Restart = "always";
      User = user;
      Group = group;
      WorkingDirectory = "${endoreg-client-manager-path}/endoreg_client_manager";
      Environment = [
        "PATH=${endoreg-client-manager-path}/.venv/bin:/run/current-system/sw/bin"
        "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib" #
        "CUDA_PATH=${pkgs.cudatoolkit}"
      ];
      DevicePolicy = "closed";
      DeviceAllow = [
        "/dev/nvidiap rw"
        "/dev/nvidiactl rw"
        "/dev/nvidia-uvm rw"
        "/dev/nvidia-uvm-tools rw"
        "/dev/nvidia0 rw"
        # Add other necessary devices
      ];
    };
  };
}

#####

# { 
#   config, pkgs,
#   endoreg-client-manager-config,
#   ...}: 

# let 

#   # Get attributes from the configuration
#   endoreg-client-manager-path = endoreg-client-manager-config.path;
#   DROPOFF_DIR = endoreg-client-manager-config.dropoff-dir;
#   PSEUDO_DIR = endoreg-client-manager-config.pseudo-dir;
#   PROCESSED_DIR = endoreg-client-manager-config.processed-dir;
#   DJANGO_DEBUG = endoreg-client-manager-config.django-debug;
#   user = endoreg-client-manager-config.user;
#   group = endoreg-client-manager-config.group;
#   port = endoreg-client-manager-config.port;
#   custom-config-path = ../../config + ("/${config.networking.hostName}");

#   client-manager-config-path = custom-config-path + ("/client-manager-config.json");

# in
#   {

#     environment.etc."endoreg-client-config/hdd.json".source = ../../config/hdd.json;
#     environment.etc."endoreg-client-config/multilabel-ai-config.json".source = ../../config/multilabel-ai-config.json;
#     environment.etc."endoreg-client-config/endoreg-center-client.json".source = ../../config/endoreg-center-client.json;
#     environment.etc."endoreg-client-config/client-manager-config.json".source = client-manager-config-path;

#     systemd.services.endoreg-client-manager = {
#       after = [ "network.target" "redis-endoreg-client-manager.service" ];
#       requires = [ "redis-endoreg-client-manager.service" ];
#       wantedBy = [ "multi-user.target" ];
#       script = ''
#         # Setup environment
#         nix develop
#         exec ${pkgs.poetry}/bin/poetry update
#         export DJANGO_SECRET_KEY=$(cat ${endoreg-client-manager-path}/.env/secret)
#         ${pkgs.python311Packages.gunicorn}/bin/gunicorn endoreg_client_manager.wsgi:application --bind 0.0.0.0:${toString port}
#       '';
#       serviceConfig = {
#         Restart = "always";
#         # User = user;
#         # Group = group;
#         User = "root"; 
#         Group = "root";
#         WorkingDirectory = "${endoreg-client-manager-path}/endoreg_client_manager";
#         Environment = [
#           "PATH=${endoreg-client-manager-path}/.venv/bin:/run/current-system/sw/bin"
#           "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
#           "CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}"
#           # "EXTRA_CCFLAGS=-I/usr/include"
#           # "EXTRA_LDFLAGS=-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
#           # Make sure CUDA and other necessary paths are included
#         ];
#         DevicePolicy = "closed";
#         DeviceAllow = [
#           "/dev/nvidiactl rw"
#           "/dev/nvidia-uvm rw"
#           "/dev/nvidia-uvm-tools rw"
#           "/dev/nvidia0 rw"
#           # Add other necessary devices
#         ];
#       };
#     };