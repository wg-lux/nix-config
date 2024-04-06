{ 
    config, pkgs,
    agl-network-config,
    ... 
}: 

let 
    hostname = config.networking.hostName;
    grafana-secret-path = ../secrets + ("/" + "${hostname}/services/grafana.yaml");
    # FIXME 
    grafana_home_dir = "/var/lib/grafana";
    secret_dir = "/var/lib/shared/grafana";
    env_file = "${grafana_home_dir}/.env";
    secret_path = "${secret_dir}/secret";
    keycloak_client_secret_path = "${secret_dir}/keycloak-client-secret";
    admin_init_pwd_path = "${secret_dir}/admin-init-pwd";
    logfile_path = "/var/log/grafana-env-generation.log";

    secret = "\$__file{${secret_path}}";
    admin_init_pwd = "\$__file{${admin_init_pwd_path}}";
    keycloak_client_secret = "\$__file{${keycloak_client_secret_path}}";

    grafana-ip = agl-network-config.services.grafana.ip;
    grafana-port = agl-network-config.services.grafana.port;
    grafana-url = agl-network-config.services.grafana.url;
   
in
{
    # Secret management using sops
    sops.secrets."services/grafana/keycloak-client-secret" = {
        sopsFile = grafana-secret-path;
        owner = "grafana";
        path = "${keycloak_client_secret_path}";
    };
    sops.secrets."services/grafana/secret" = {
        sopsFile = grafana-secret-path;
        owner = "grafana";
        path = "${secret_path}";
    };
    sops.secrets."services/grafana/admin-init-pwd" = {
        sopsFile = grafana-secret-path;
        owner = "grafana";
        path = "${admin_init_pwd_path}";
    };

    # Networking configuration
    networking.firewall.allowedTCPPorts = [ grafana-port ];

    # Grafana service configuration
    services.grafana = {
        enable = true;
        dataDir  = grafana_home_dir;
        settings = {
            # smtp.password = ""; # if necessary
            users = {
                viewers_can_edit = false;
                verify_email_enabled = false;
                allow_sign_up = false;
                hidden_users = "agl-admin"; #comma separated list of hidden users 
                editors_can_admin = false;
                default_theme = "dark";
                default_language = "en-US";
                # auto_assign_org_role = "Viewer";
                auto_assign_org = true;
            };
            server = {
                # serve_from_sub_path = false;
                root_url = grafana-url; 
                http_port = grafana-port;
                http_addr = grafana-ip; 
                enable_gzip = true;
            };
            database = {

            };
            security = {
                cookie_secure = true; # set true when hosted behind https
                secret_key = secret;
                admin_password = admin_init_pwd;
            };
            "auth.generic_oauth" = {
                enabled = true;
                name = "OAuth";
                allow_sign_up = true;
                skip_org_role_sync = true;
                client_id = "agl-grafana";
                client_secret =  keycloak_client_secret ;
                scopes = "openid acr profile email offline_access roles";
                auth_url = "https://keycloak.endo-reg.net/realms/master/protocol/openid-connect/auth";
                token_url = "https://keycloak.endo-reg.net/realms/master/protocol/openid-connect/token";
                api_url = "https://keycloak.endo-reg.net/realms/master/protocol/openid-connect/userinfo";
                # role_attribute_path = '' contains(roles[*], 'admin') && 'Admin' || contains(roles[*], 'editor') && 'Editor' || 'Viewer' '';
                role_attribute_path = "contains(roles[*], 'admin') && 'Admin' || contains(roles[*], 'editor') && 'Editor' || 'Viewer' ";
            };
        };
    };
}


## DEPRECEATED CONFIGURATION
 # generateEnvScriptPath = pkgs.writeScript "generate-env.sh" ''
    # # Make sure grafana home directory exists
    # mkdir -p "${grafana_home_dir}"

    # echo "Running generate-env.sh script" #|  tee -a "${logfile_path}"

    # # Create or clear the environment file
    # tee "${env_file}" </dev/null

    # # Writing secrets to the environment file
    # echo "SECRET_KEY=$(cat ${secret_path})" | tee -a "${env_file}"
    # echo "ADMIN_PASSWORD=$(cat ${admin_init_pwd_path})" | tee -a "${env_file}"
    # echo "KEYCLOAK_CLIENT_SECRET=$(cat ${keycloak_client_secret_path})" | tee -a "${env_file}"

    # # Ensure the file is only readable by the grafana user
    # chown grafana:grafana -R "${grafana_home_dir}"
    # chmod 777 -R "${grafana_home_dir}"

    # # Log success or failure
    # if [[ $? -eq 0 ]]; then
    #     echo "Environment file created successfully" # | tee -a "${logfile_path}"
    # else
    #     echo "Failed to create environment file" # | tee -a "${logfile_path}"
    # fi
    # '';


    # Custom service for environment preparation
    # systemd.services."grafana-env-preparation" = {
    #     script = "${generateEnvScriptPath}";
    #     serviceConfig = {
    #         # trigger some change
    #         User = "root";
    #         Group = "root";
    #     };
        # type = "oneshot";
        # remainAfterExit = true;
        # after = [ "network.target" ];
        # wantedBy = [ "multi-user.target" ];
        # requires = [ "network.target" ];
    # };

    ## Main Grafana service configuration
    # systemd.services.grafana = {
    #     after = [ "grafana-env-preparation.service" ];
    #     wants = [ "grafana-env-preparation.service" ];
    #     serviceConfig = {
    #         EnvironmentFile = "${env_file}";
    #         User = "grafana";
    #         Group = "grafana";
    #     };
    # };