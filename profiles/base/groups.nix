{ openvpn-config, ... }:
{
    users.groups.service-user = {
      members = [
        "agl-admin"
        "maintenance-user"
        "service-user" 
      ];
    };

    users.groups.keys = {
      members = [
        "agl-admin"
        # "maintenance-user"
        # "service-user" 
      ];
    };

    users.groups.endoreg-service = {
      members = [
        "agl-admin"
        "maintenance-user"
        "service-user" 
      ];
    };

    users.groups.dropoff-access = {
      members = [
        "service-user"
        "center-user"
        "agl-admin" #TODO REMOVE AFTER TESTING
      ];#
    };

    users.groups.pseudo-access = {
      members = [
        "service-user"
        "agl-admin" #TODO REMOVE AFTER TESTING
      ];
    };

    users.groups.processed-access = {
      members = [
        "service-user"
        # "agl-admin" #TODO REMOVE AFTER TESTING
      ];
    };

    users.groups."${openvpn-config.group}" = {
      members = [
        openvpn-config.user
      ];
    };
}