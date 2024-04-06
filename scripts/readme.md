# use in configuration.nix

{ config, pkgs, ... }:

{
    environment.systemPackages = [
        # .....
        (import ./my-awesome-script.nix {inherit pkgs;})
    ];
}
