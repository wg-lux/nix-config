let
    service-configs = {
        anonymizer = import ./custom-services/anonymizer.nix;
        client-manager = import ./custom-services/client-manager.nix;
        custom-logs = import ./custom-services/custom-logs.nix;
        endoreg-home = import ./custom-services/endoreg-home.nix;
        frame-predictor = import ./custom-services/frame-predictor.nix;
        main-nginx = import ./custom-services/main-nginx.nix;
        monitor = import ./custom-services/monitor.nix;
        nextcloud = import ./custom-services/nextcloud.nix;
        openvpn = import ./custom-services/openvpn.nix;
        scripts = import ./custom-services/scripts.nix;
        sops = import ./custom-services/sops.nix;
        ssh = import ./custom-services/ssh.nix;
        zsh = import ./custom-services/zsh.nix;
    };
in service-configs;