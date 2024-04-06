{ config, lib, pkgs, ... }:

{
    # Use the xdg user dirs module to ensure the Desktop directory is managed
    # xdg.userDirs.enable = true;

    # 
    home.activation.linkDropOff = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ln -sfn /mnt/hdd-sensitive/DropOff/data $HOME/Desktop/DropOff
'';

}
