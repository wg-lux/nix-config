{ 
  config, pkgs, 
  endoRegClientManagerPath,
  ...}: 

let 
    user = "agl-admin";
in
    {

    systemd.services.endoreg-client-manager-flower = {
    after = [ "network.target" "endoreg-client-manager.service" ];
    requires = [ "endoreg-client-manager.service" ];
    wantedBy = [ "multi-user.target" ];
    description = "Flower Celery Management";

    script = ''
      # Activate the Python virtual environment
      source ${endoRegClientManagerPath}/.venv/bin/activate
      
      # Set the Django settings module environment variable
      export DJANGO_SETTINGS_MODULE=endoreg_client_manager.settings

      celery -A endoreg_client_manager flower --address=127.0.0.1 --port=5555
      
    '';
    serviceConfig = {
      Restart = "always";
      User = user; # Replace with the user you want the service to run as
      # Group = "agl-admin"; # Replace with the group you want the service to run as
      # It's important to set the working directory to where your Django project is
      WorkingDirectory = "${endoRegClientManagerPath}/endoreg_client_manager";
      # Add environment variables if necessary
      Environment = [
        "PATH=${endoRegClientManagerPath}/.venv/bin:/run/current-system/sw/bin"
        "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
        "CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}"
        "EXTRA_LDFLAGS=-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
        "EXTRA_CCFLAGS=-I/usr/include"
      ];
    };
  };
}