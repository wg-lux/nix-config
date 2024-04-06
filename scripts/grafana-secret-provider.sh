#!/usr/bin/env bash

# Path to the decrypted secrets
secret_path="/var/lib/grafana/.secret" # grafana home dir

# Path to the environment file
env_file="/var/lib/grafana/.env"

# Create or clear the environment file
: > "$env_file"

# Example: Writing secrets to the environment file
echo "SECRET_KEY=$(cat $secret_path/secret_key)" >> "$env_file"
echo "ADMIN_PASSWORD=$(cat $secret_path/admin_password)" >> "$env_file"
# Add more secrets as needed

# Ensure the file is only readable by the grafana user
chown grafana:grafana "$env_file"
chmod 600 "$env_file"
