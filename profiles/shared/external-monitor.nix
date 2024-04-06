{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        autorandr
    ];
}