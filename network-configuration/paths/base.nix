let
    custom-logs-dir = "/etc/custom-logs";

    sensitive-data-mountpoint = "/mnt/sensitive";
    sensitive-data-temporary = "/etc/temporary-sensitive-data";
    dropoff = "${sensitive-data-mountpoint}/DropOff";
    processing = "${sensitive-data-mountpoint}/Processing";
    processed = "${sensitive-data-mountpoint}/Processed";

    etc-source-dir = ../../config/etc;
    secret-source-root = ../../secrets;
    shared-secret-source-root = "${secret-source-root}/shared";
    shared-openvpn-secret-file = "${shared-secret-source-root}/openvpn.yaml"; 

in
{
    ##### Default Filenames #####
    default.filenames = {
        celery-signal-log = "celery-signal.log";
        django-log = "django.log";
        celery-log = "celery.log";
    };

    default.paths = {
        custom-logs-dir = custom-logs-dir;
        etc-source-dir = etc-source-dir;
        secret-source-root = secret-source-root;
        shared-secret-source-root = shared-secret-source-root;
    };

    sops = {
        sops-files = {
            openvpn-shared-secrets = shared-openvpn-secret-file;
            # host specific sopsfile paths are added in 
        };

        file-targets = { 
        };

        sops-targets = {# refers to sops targets in yaml file-structure
            openvpn-shared-ta-key = "shared/openvpn-aglNet/server-ta-key"; 
            openvpn-shared-ca-cert = "shared/openvpn-aglNet/ca-cert";
            openvpn-host-dh-pem = "services/openvpn-aglNet/dh-pem";
            openvpn-host-server-cert = "services/openvpn-aglNet/server-cert";
            openvpn-host-server-key = "services/openvpn-aglNet/server-key";
        };

    };

    storage = {
        sensitive-data = {
            mountpoint = sensitive-data-mountpoint;
            temporary = sensitive-data-temporary;
            dropoff = dropoff;
            processing = processing;
            processed = processed;
        };
    };
}