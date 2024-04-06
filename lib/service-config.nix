# lib/service-config.nix

{ pkgs, ... }: {

#   services = {
#     endoreg-client-manager = {
#       port = 9100;
#       redis-port = 6379;
#     };
#     synology = {
#       drive = {
#         ip = "172.16.255.121"; # Re-use from network-config if possible
#         port = 12313;
#       };
#       chat = {
#         ip = "172.16.255.121";
#         port = 22323;
#       };
#       video = {
#         ip = "172.16.255.121";
#         port = 9946;
#       };
#       dsm = {
#         ip = "172.16.255.121";
#         port = 5545;
#       };
#     };
#     monitoring = {
#       grafana = {
#         port = 3010;
#       };
#       prometheus = {
#         port = 3020;
#         node-exporter-port = 3021;
#       };
#       loki = {
#         port = 3030;
#       };
#       promtail = {
#         port = 3031;
#       };
#     };
#     nfs-share = {
#       local-path = "/home/agl-admin/nfs-share";
#       mount-path = "/volume1/agl-share";
#     };
#     openvpn = {
#       configPath = "/home/agl-admin/.openvpn";
#       certPath = "/home/agl-admin/openvpn-cert";
#     };
#     endoreg-client-manager-config = {
#       path = "/home/agl-admin/endoreg-client-manager";
#       dropoff-dir = "/mnt/hdd-sensitive/DropOff";
#       pseudo-dir = "/mnt/hdd-sensitive/Pseudo";
#       processed-dir = "/mnt/hdd-sensitive/Processed";
#       django-debug = "True";
#       user = "agl-admin";
#       group = "pseudo-access";
#     };
#   };

}
