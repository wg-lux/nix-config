{config, pkgs}:

pkgs.writeShellScriptBin "base-ssh-add" ''
#!/usr/bin/env bash
# Check if SSH agent has the key already
if ! ssh-add -l | grep -q "id_ed25519"; then
  # Add the SSH key
  # You can also add a passphrase here if your key is protected
  ssh-add /home/agl-admin/.ssh/id_ed25519 </dev/null
fi''