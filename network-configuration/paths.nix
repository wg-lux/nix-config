let

    paths = {
        anonymizer = import ./paths/anonymizer.nix;
        base = import ./paths/base.nix;
        client-manager = import ./paths/client-manager.nix;
        etc = import ./paths/etc.nix;
        endoreg-home = import ./paths/endoreg-home.nix;
        frame-predictor = import ./paths/frame-predictor.nix;
        identity = import ./paths/identity.nix;
        monitor = import ./paths/monitor.nix;
        nfs-share = import ./paths/nfs-share.nix;
        nginx = import ./paths/nginx.nix;
        openvpn = import ./paths/openvpn.nix;
    };   

in paths
