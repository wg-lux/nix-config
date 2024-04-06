{
    pkgs,
    ...
}:

{
    # Maybe for later? add hostname if so
    # sops.secrets."main/ssid" = {
    #     sopsFile = ../../secrets/${hostname}/wpa_supplicant.yaml;
    #     path = "/etc/wpa_supplicant_main_ssid";
    # };

    # sops.secrets."main/pskRaw" = {
    #     sopsFile = ../../secrets/${hostname}/wpa_supplicant.yaml;
    #     path = "/etc/wpa_supplicant_main_pskRaw";
    # };


    # networking.networkmanager.enable = pkgs.lib.mkForce false;

    # networking.wireless = {
    #     enable = true;
    #     # Uses /etc/wpa_supplicant.conf when left empty
    #     networks = {
    #         # ExampleSSID = {                # SSID with no spaces or special characters
    #         #     # Create with wpa_passphrase ExampleSSID ExamplePassword
    #         #     pskRaw = "37858d3f2d310a0c8c329bd9c58de1284191baff66eae0be63fc8c8ec413d0c1";
    #         # };
    #     };
    # };

}