{lib, ...}: {
  home.activation = {
    # setFilePermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #     $DRY_RUN_CMD chmod 700 -R ~/openvpn-cert
    #     $DRY_RUN_CMD chmod 700 -R ~/.ssh
    #     $DRY_RUN_CMD mkdir -p ~/logs/openvpn
    #   '';
    # setFilePermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #     run sudo chmod 700 -R ~/openvpn-cert
    #     run sudo chmod 700 -R ~/.ssh
    #     run sudo mkdir -p ~/logs/openvpn
    #   '';
    };
}