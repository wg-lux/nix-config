let
    identityPaths = import ./identity.nix;

in {
    file-targets = {
        default-key-file = identityPaths.age-key-file-user;
        etc-age-key-file = identityPaths.age-key-file;
    };

    sops-targets = {
        # default-key-file = identityPaths.age-key-file; # Must be manually provided during deployment
        etc-age-key-file = "age-keys-txt";
        openvpn-client-cert = "services/openvpn/aglNet-client/cert";
        openvpn-client-key = "services/openvpn/aglNet-client/key";
    };

    sops-files = {
    };
}