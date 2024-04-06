{ 
  config, pkgs, lib,
  endoreg-client-manager-config,
  ...}: 

let 
    endoreg-client-manager-path = endoreg-client-manager-config.path;
    user = endoreg-client-manager-config.user;
    group = endoreg-client-manager-config.group;
    redis-port = endoreg-client-manager-config.redis-port;
in
    {
    services.redis.servers."endoreg-client-manager"= { # results in service named: redis-endoreg-client-manager.service 
      enable = true;
      bind =  "127.0.0.1"; #"127.0.0.1"; 
      port = redis-port;
      settings = {
        # Set Redis to listen on all interfaces; adjust according to your security requirements
        # bind = lib.mkForce "127.0.0.1"; #"127.0.0.1"; 
        # Default Redis port is 6379, change if necessary
        # port = lib.mkForce 6379;
        # Configure other settings as needed, for example, password protection, databases, etc.
        # requirepass = "yoursecurepassword";
      };
    };

    environment.systemPackages = [
      pkgs.redis
    ];

    systemd.services.endoreg-client-manager-celery = {
    after = [ "network.target" "endoreg-client-manager.service" ];
    requires = [ "endoreg-client-manager.service" ];
    wantedBy = [ "multi-user.target" ];

    script = ''
      nix develop
      
      # Set the Django settings module environment variable
      export DJANGO_SETTINGS_MODULE=endoreg_client_manager.settings

      exec celery -A endoreg_client_manager worker --loglevel=INFO 
      
    '';
    serviceConfig = {
      Restart = "always";
      User = user; 
      Group = group;
      WorkingDirectory = "${endoreg-client-manager-path}/endoreg_client_manager";
      # Add environment variables if necessary
      Environment = [
        "PATH=${endoreg-client-manager-path}/.venv/bin:/run/current-system/sw/bin"
        "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
        "CUDA_PATH=${pkgs.cudatoolkit}"
        "CUDA_HOME=${pkgs.cudatoolkit}"
        "EXTRA_LDFLAGS=-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
        "EXTRA_CCFLAGS=-I/usr/include"
      ];
      DevicePolicy = "closed";
      DeviceAllow = [
        "/dev/nvidiactl rw"
        "/dev/nvidia-uvm rw"
        "/dev/nvidia-uvm-tools rw"
        "/dev/nvidia0 rw"
        # Add other necessary devices
      ];
    };
  };

  systemd.services.endoreg-client-manager-celery-beat = {
    after = [ 
      "network.target"
      "endoreg-client-manager.service"
      "redis-endoreg-client-manager.service"
      "endoreg-client-manager-celery.service"  
    ]; # Ensure Redis is started as well
    requires = [ "endoreg-client-manager.service" "redis-endoreg-client-manager.service" ];
    wantedBy = [ "multi-user.target" ];
    description = "Celery Beat for EndoReg Client Manager";

    script = ''
      nix develop
      
      # Set the Django settings module environment variable
      export DJANGO_SETTINGS_MODULE=endoreg_client_manager.settings

      # Start Celery Beat
      exec celery -A endoreg_client_manager beat --loglevel=INFO --scheduler django_celery_beat.schedulers:DatabaseScheduler 
    
    '';
    serviceConfig = {
      Restart = "always";
      User = user;
      group = group;
      WorkingDirectory = "${endoreg-client-manager-path}/endoreg_client_manager";
      Environment = [
        "PATH=${endoreg-client-manager-path}/.venv/bin:/run/current-system/sw/bin"
        "LD_LIBRARY_PATH=${pkgs.glibc}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib"
        "CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}"
        "CUDA_HOME=${pkgs.cudaPackages.cudatoolkit}"
        "EXTRA_LDFLAGS=-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
        "EXTRA_CCFLAGS=-I/usr/include"
      ];
      DevicePolicy = "closed";
      DeviceAllow = [
        "/dev/nvidiactl rw"
        "/dev/nvidia-uvm rw"
        "/dev/nvidia-uvm-tools rw"
        "/dev/nvidia0 rw"
        # Add other necessary devices
      ];
    };
  };


}