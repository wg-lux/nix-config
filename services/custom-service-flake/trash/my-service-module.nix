{ lib, nvidiaCache, ... }:

{
  options.services.myCustomService = {
    enable = lib.mkEnableOption "My custom service";
    path = lib.mkOption {
      type = lib.types.str;
      default = "/home/agl-admin/my-service.log";
      description = "Path to the log file.";
    };
    pythonFilePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/agl-admin/nix-config/services/custom-service-flake/my-service.py";
      description = "Path to the python file.";
    };
  };

  config = lib.mkIf config.services.myCustomService.enable {
    systemd.services.myCustomService = {
      description = "My Custom Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = let
        pythonEnv = import ./path/to/your/flake.nix { inherit nvidiaCache; }.packages.pythonWithPytorch;
      in ''
        ${pythonEnv}/bin/python ${config.services.myCustomService.pythonFilePath} > ${config.services.myCustomService.path}
      '';
    };
  };
}
