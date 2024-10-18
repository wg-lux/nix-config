let 
    users = import ./users.nix;

    user = users.admin-user;

in {
    ssh-id-ed25519-file-path = "/etc/${user}-identity/id_ed25519";
    age-key-file = "/etc/${user}-identity/age-keys.txt"; 
    age-key-file-user = "/home/${user}/.config/sops/age/keys.txt";

    ssl-certificate-path = "/etc/endoreg-cert/__endo-reg_net_chain.pem";
    ssl-certificate-key-path = "/etc/endoreg-cert/endo-reg-net-lower-decrypted.key";

    openvpn-cert-path = "/etc/openvpn-cert";

}