{pkgs}:

pkgs.writeShellScriptBin "manage_agl_home_django" ''
#!/usr/bin/env bash

# Define the repository location and the path to the Django application
REPO_URL="git@github.com:wg-lux/agl-home-django.git"
REPO_DIR="/home/agl-admin/agl-home-django"

# Check if ~/agl-home-django exists
if [ ! -d "$REPO_DIR" ]; then
    # Clone the repository if it doesn't exist
    git clone "$REPO_URL" "$REPO_DIR"
else
    # Run git pull if the repository already exists
    cd "$REPO_DIR" && git pull
fi

direnv allow "$REPO_DIR"
rm -rf $REPO_DIR/nix-agl-home-django

nix-shell $REPO_DIR/shell.nix --run "nix build $REPO_DIR -o $REPO_DIR/nix-agl-home-django"

sudo systemctl restart agl-home-django
''