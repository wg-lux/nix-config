let 
    service-group = "service-user";
in {
    service = service-group;
    monitor = service-group;

    openvpn = "openvpn";
    nextcloud = "nextcloud";

    endoreg-client-sensitive-access = "erc-sensitive-access";

    # Users Extra Groups
    admin-user-extra-groups = [ 
        "networkmanager" 
        "wheel" 
        "video" 
        "sound"
        "audio"
        "pulse-access"
    ];

    service-user-extra-groups = [ 
        "networkmanager"
        "wheel"
        service-group
    ];

    base-user-extra-groups = [ 
        "audio" 
        "sound"
    ];

}