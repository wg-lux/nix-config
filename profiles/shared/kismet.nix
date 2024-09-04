{pkgs, ...}: 

{

  # DID NOT WORK, TRYING WITH WIRESHARK
  environment.systemPackages = with pkgs; [
    kismet
  ];

  users.groups.kismet = {
    members = [
      "agl-admin"
      "maintenance-user"
      "service-user"
    ];
  };
}
