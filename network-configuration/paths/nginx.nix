let
    identity = import ./identity.nix;

{
    ssl-certificate-key-path = identity.ssl-certificate-key-path;
    ssl-certificate-path = identity.ssl-certificate-path;
}