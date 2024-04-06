{ config, pkgs, ... }: 

let
  # Ensure netcat is available in the environment for the script
  netcat = pkgs.netcat;
  hostname = config.networking.hostName;

  keycloak-secret-path = ../secrets + ( "/" + "${hostname}/services/keycloak.yaml" );

in

{

    sops.secrets."services/keycloak/database/postgresql/pwd" = {
        sopsFile = keycloak-secret-path;
        owner = "agl-admin";
        path = "/home/agl-admin/.config/keycloak-pwd";
    };

    networking.firewall.allowedTCPPorts = [ 8080 8443 80 443];
    
    systemd.services.keycloak = {
        wants = [ "openvpn-aglNet.service" "network-online.target" ];
        after = [ "openvpn-aglNet.service" "network-online.target" ];
        serviceConfig = {
        # Add a pre-start script to check for database connectivity
        ExecStartPre = pkgs.writeScript "check-db-connectivity.sh" ''
            #!/bin/sh
            until ${netcat}/bin/nc -z 172.16.255.4 5432; do
            echo "Waiting for database connectivity..."
            sleep 1
            done
        '';
        };
    };

    services.keycloak = {
        enable = true;
        initialAdminPassword = "changeme";
        settings = {
            http-host = "127.0.0.1"; #
            http-port = 8080;
            https-port = 8443; 
            proxy = "edge"; # none (default), edge, reencrypt, passthrough;  The proxy address forwarding mode if the server is behind a reverse proxy. https://www.keycloak.org/server/reverseproxy for
        #     # hostname-strict-backchannel = false;
            hostname = "keycloak.endo-reg.net"; # The public host name of the Keycloak server, used for public URL generation
        };
        sslCertificateKey = "/home/agl-admin/endoreg-cert/endo-reg-net-lower-decrypted.key" ; # The path to a PEM formatted private key to use for TLS/SSL connections
        sslCertificate = "/home/agl-admin/endoreg-cert/__endo-reg_net_chain.pem" ; # The path to a PEM formatted certificate to use for TLS/SSL connections
        database = {
            type = "postgresql"; # one of "mysql", "mariadb", "postgresql"
            username = "keycloak";
            useSSL = false; 
            port = 5432; # default is default port for database.type
            passwordFile = "/home/agl-admin/.config/keycloak-pwd"; # path to pwd file
            name = "keycloak";
            host = "172.16.255.4"; # default is localhost
        #     # caCert = path; # path to ca cert file
        };
    };
}