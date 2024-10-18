let 
    admin-user = "agl-admin";
    maintenance-user = "maintenance";
    service-user = "service-user";
    center-user = "center-user";
    logging-user = "logging-user";

in {
    base-service = admin-user;
    service = service-user;
    admin = admin-user;
    maintenance = maintenance-user;
    center = center-user;
    logging = logging-user;
    openvpn = "openvpn";
    nextcloud = "nextcloud";
}