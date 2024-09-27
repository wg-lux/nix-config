{ inputs, config, pkgs, lib,
  custom-hardware-config, ip, hostname, agl-network-config,
  ... 
}:
let
  ip = agl-network-config.ips.${hostname};
  endoreg-client-manager-config = agl-network-config.endoreg-client-manager-config;
  endoreg-client-manager-path = endoreg-client-manager-config.path;

  network-interface = custom-hardware-config.network-interface;
  nvidiaBusId = custom-hardware-config.nvidiaBusId;
  onboardGraphicBusId = custom-hardware-config.onboardGraphicBusId;

in  
{

  imports =
    [
      (
        import ../endoreg-clients/base.nix {
          inherit config pkgs lib;
          inherit custom-hardware-config ip hostname agl-network-config;
        }
      )

      # Auto Decrypt Hdd on Dev Machine
      (import ../endoreg-clients/luks-base-decrypt.nix { inherit config custom-hardware-config; })

      # Networking
      # ./wpa_supplicant.nix

      # ( 
      #   import ./local-monitoring/local-monitoring.nix {
      #     inherit pkgs config ip;
      #     inherit agl-network-config;
      #   } 
      # )
      
      ( import ../shared/local-nginx.nix { 
        inherit agl-network-config;
      })

      (
        import ../shared/nfs-share.nix {
          inherit pkgs;
          inherit agl-network-config;
        } 
      )
      
    ];

    # services.agl-anonymizer = {
    #     enable = true;
        # config = {
        #     tmp_dir = "${agl-anonymizer.dir}/tmp";
        #     blurred_dir = "${agl-anonymizer.dir}/blurred";
        #     csv_dir = "${agl-anonymizer.dir}/csv";
        #     results_dir = "${agl-anonymizer.dir}/results";
        #     models_dir = "${agl-anonymizer.dir}/models";
        # };
        # user = "anonymizer";
        # group = "service-user";
        # django-config = {
        #     debug = false;
        #     settings_module = "agl_anonymizer.settings";
        #     port = 9123;
        # };
    # };

  system.stateVersion = "23.11";

}
