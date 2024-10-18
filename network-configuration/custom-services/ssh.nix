let
    users = import ../users.nix;
    sshuser = users.agl-admin-user;
    secret-file-mode = "0600";
in {
    secret-file-mode = secret-file-mode;
    user = user;
}