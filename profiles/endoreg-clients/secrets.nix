{config, endoRegClientManagerPath, hostname,...}:

let

    sensitive-hdd-secret-path = ../../secrets + ( "/" + "${hostname}/sensitive-hdd.yaml");
    endoreg-center-client-secrets-path = ../../secrets + ( "/" + "${hostname}/endoreg-center-client.yaml");

in

    {
        sops.secrets."endoreg-center-client/django-secret-key" = {
            sopsFile = endoreg-center-client-secrets-path;
            path = "${endoRegClientManagerPath}/.env/secret";
            format = "yaml";
            owner = "agl-admin";
        };

        ###### HDD ENCRYPTION KEYS ######
        sops.secrets."sensitive-hdd/key/DropOff" = {
            sopsFile = sensitive-hdd-secret-path;
            path = "/root/.secrets/hdd-key-dropoff";
            format = "yaml";
            mode = "700";
        };

        sops.secrets."sensitive-hdd/key/Pseudo" = {
            sopsFile = sensitive-hdd-secret-path;
            path = "/root/.secrets/hdd-key-pseudo";
            format = "yaml";
            mode = "700";
        };

        sops.secrets."sensitive-hdd/key/Processed" = {
            sopsFile = sensitive-hdd-secret-path;
            path = "/root/.secrets/hdd-key-processed";
            format = "yaml";
            mode = "700";
        };
    }