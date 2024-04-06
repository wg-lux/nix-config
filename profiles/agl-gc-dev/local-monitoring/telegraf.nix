{ 
  config, pkgs, hostname,
  ...
}: 

let 
  influx-secret-path = ../../../secrets + ("/" + hostname ) + /influxdb.yaml;

  t_sysd_port = 8125;
  influxdb_port = 8086; # IS DEFAULT PORT IN INFLUXDB

in

{

  environment.systemPackages = with pkgs; [
    # telegraf
    # influxdb2-cli
  ];

# ${hostname}
  sops.secrets = {
    "telegraf/users/initial-user/token".sopsFile = influx-secret-path;
    "telegraf/users/initial-user/password".sopsFile = influx-secret-path;
    "telegraf/users/telegraf/password".sopsFile = influx-secret-path;
    "telegraf/users/maintenance/password".sopsFile = influx-secret-path;
    "telegraf/organizations/hostname/token".sopsFile = influx-secret-path;
  };

  sops.secrets."telegraf/manual-token" = {
    sopsFile = influx-secret-path;
  };

  sops.templates."telegraf.env".content = ''
    TOKEN='${config.sops.placeholder."telegraf/manual-token"}'
  '';

  

  services.influxdb2 = {
    enable = true;
    provision = {
      initialSetup = {
        username = "agl-admin";
        bucket = "primary";
        tokenFile = config.sops.secrets."users/initial-user/token".path;
        passwordFile = config.sops.secrets."users/initial-user/password".path;
      };

      organizations = {
        "test-org" = {
          buckets = {
            "test-bucket" = {
              description = "Test bucket";
              retention = "7d";
            };
          };
        };
      };
      #   hostname = {
      #     buckets = {
      #       "telegraf".description = "Telegraf metrics";
      #       "telegraf".retention = "30d";

      #     };
      #     auths = {
      #       # "telegraf" = {
      #         ## operator = true; # Grants all permissions in all organizations
      #         ## allAccess = true; # Grants all permissions in the associated organization.
      #         # writePermissions = ["telegraf"];  # define single resources, quite complicated https://search.nixos.org/options?channel=23.11&show=services.influxdb2.provision.organizations.%3Cname%3E.auths.%3Cname%3E.writePermissions&from=0&size=50&sort=relevance&type=packages&query=influxdb2
      #         # writeBuckets = 
      #         # readPermissions = 
      #         # readBuckets =
      #         # tokenFile = 
      #       # };
      #     };
      #   };

      # };

      users = {
        "telegraf".passwordFile = config.sops.secrets."telegraf/password".path;
        "maintenance" = {
          passwordFile = config.sops.secrets."users/maintenance/password".path;
          tokenFile = config.sops.secrets."users/maintenance/token".path;
        };
      };
    };
    # settings = {

    # };

  };


  services.telegraf = {
    enable = true;
    environmentFiles = [
      config.sops.templates."telegraf.env".path
    ];

    extraConfig = {

      agent = {
        interval = "10s";
        round_interval = true;
        metric_batch_size = 1000;
        metric_buffer_limit = 10000;
        collection_jitter = "0s";
        flush_interval = "10s";
        flush_jitter = "0s";
        precision = "";
        debug = false;
        quiet = false;
        hostname = "";
        omit_hostname = false;
      };

      inputs = {
        statsd = {
          delete_timings = true;
          service_address = ":${toString t_sysd_port}";
        };
      };

      # OUTPUTS
      outputs = {
        influxdb_v2 = {
          bucket = "telegraf";
          token =  "$TOKEN"; 
          organization = hostname;
          
          urls = [
            "http://127.0.0.1:${toString influxdb_port}"
          ];
          # retention_policy = "";
          ## Write consistency (clusters only), can be: "any", "one", "quorum", "all"
          # write_consistency = "any";
          ## Write timeout (for the InfluxDB client)
          ## formatted as a string. if not provided, will default to 5s. 0s means no timeout (not recommended).
          # timeout = "5s";
          # username = "telegraf";
          # password = "noice"; ######### FIXME 
          # user_agent = "${hostname}-telegraf";
          ## set udp payload size, defaults to InfluxDB UDP Client default (512 bytes)
          # udp_payload = 512;
        };
      };

      # INPUTS
      inputs = {

        cpu = {
          percpu = true;
          totalcpu = true;
          fieldexclude = ["time_*"];
        };

        disk = {
          ## By default, telegraf gather stats for all mountpoints.
          ## Setting mountpoints will restrict the stats to the specified mountpoints.
          # mount_points = ["/"]

          ## Ignore some mountpoints by filesystem type. For example (dev)tmpfs (usually
          ## present on /run, /var/run, /dev/shm or /dev).
          ignore_fs = ["tmpfs" "devtmpfs"];
        };

        diskio = {
          ## By default, telegraf will gather stats for all devices including
          ## disk partitions.
          ## Setting devices will restrict the stats to the specified devices.
          # devices = ["sda", "sdb"]
          ## Uncomment the following line if you need disk serial numbers.
          # skip_serial_number = false
        };

        kernel = {}; # no configuration
        mem = {}; # no configuration
        processes = {}; # no configuration
        swap = {}; # no configuration
        system = {}; # no configuration

        net = {
          # collect data only about specific interfaces
          # interfaces = ["eth0"]
        };
        netstat = {};
        interrupts = {};
        linux_sysctl_fs = {};
      };
    };
  };
}