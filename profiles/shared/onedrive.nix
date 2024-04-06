{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        onedrivegui
    ];
    
    services.onedrive.enable = true;

}