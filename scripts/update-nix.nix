{config, pkgs}:

pkgs.writeShellScriptBin "update-nix" ''
#!/usr/bin/env bash
sudo nixos-rebuild switch --flake /home/agl-admin/nix-config
''