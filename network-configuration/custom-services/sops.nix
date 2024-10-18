let
    users = import ../users.nix;
    user = user.agl-admin-user;
    paths = import ../paths/sops.nix;

    default-format = "yaml";

in {
    user = user;
    default-format = default-format;
    paths = paths;
}