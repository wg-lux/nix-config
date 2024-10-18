let
    prefix = "nfs-share";
    prefix-underscore = "nfs_share";

    root = "/etc/${prefix}";
    
    base-share-name = "base";
    base-share-local-root = "${root}/${base-share-name}";
    base-share-mount-path = "/volume1/agl-share";

in {
    prefix = prefix;
    prefix-underscore = prefix-underscore;

    root = root;

    base-share = {
        local-root = base-share-local-root;
        mount-path = base-share-mount-path;
    };
}