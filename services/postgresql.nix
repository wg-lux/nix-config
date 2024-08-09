{ config, pkgs, ... }: {
    services.postgresql = {
        enable = true;
        package = pkgs.postgresql_15;
        settings.port = 5432;
        enableTCPIP = true;
        # dataDir= path;

        authentication = ''
        # Root access for a specific IP address
        host    all     postgres    172.16.255.70/32    scram-sha-256

        # Access for Keycloak from another machine
        host    all     keycloak    172.16.255.3/32     md5
        '';

        settings = {
            # log_connections = true;
            # log_statement = "all";
            # logging_collector = true;
            # log_disconnections = true;
            # log_destination = lib.mkForce "syslog";
        };

        ensureUsers = [
            {
                name = "keycloak";
                ensureDBOwnership = true;
            }
            {
                name = "agl-admin";
                ensureDBOwnership = true;
            }
        ];
        ensureDatabases = [
            "keycloak"
            "agl-admin"
        ];
    };

    services.postgresqlBackup = {
      enable = true;  
      startAt = "*-*-* 01:15:00"; # Daily at 1:15am
      location = "/var/backups/postgresql";
      # databases = []; list of databases to backup
      backupAll = true; # exclusive with services.postgresqlBackup.databases
    
    };

    networking.firewall.allowedTCPPorts = [ 5432 ];
    networking.firewall.allowedUDPPorts = [ 5432 ];

}