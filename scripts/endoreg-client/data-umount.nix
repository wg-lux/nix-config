{pkgs}:

pkgs.writeShellScriptBin "endoreg-umount-sensitive" ''
#!/usr/bin/env bash
sudo umount /mnt/endoreg-sensitive-data
sudo cryptsetup close endoreg-sensitive-data
''