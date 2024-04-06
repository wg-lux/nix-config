#Manual config steps:

## Cheat Sheet
### Study HDD
Mount: 
- `systemctl start mountDropOffService`
- `systemctl start mountPseudoService`
- `systemctl start mountProcessedService`

Unmount
- `systemctl start umountDropOffService`
- `systemctl start umountPseudoService`
- `systemctl start umountProcessedService`

available as script: "erc-dev"
```
sudo systemctl stop endoreg-client-manager
sudo systemctl stop endoreg-client-manager-celery
sudo systemctl stop endoreg-client-manager-celery-beat
m-do
m-pseudo
m-proc
```

### NFS Share
Mount:
```
sudo mount -t nfs -o noatime,_netdev 172.16.255.121:/volume1/agl-share /home/agl-admin/nfs-share

sudo umount -fv /home/agl-admin/nfs-share
```
# Grafana 
## Local 
### Telegraf Dashboard:
Dashboard ID: 928       

## Influx
location of persisting influx db data:
- /var/lib/influxdb2
- sudo rm -rf /var/log/influxdb #??

## TMUX
- Start with: 
    - `tmux` (new session)
    - `tmux new -s Session1` (named session) 
- detach with:
    - ctrl+B then D
- exit & close session with `exit`
- list sessions: `tmux ls`
- reconnect to detached session:
    - `tmux attach -t $SESSION_ID`
- toggle mouse input: `set -g mouse`
- Hotkeys:
    - Ctrl+B D — Detach from the current session.
    - Ctrl+B - — Split the window into two panes horizontally.
    - Ctrl+B | — Split the window into two panes vertically.
    - Ctrl+B Arrow Key (Left, Right, Up, Down) — Move between panes.
    - Ctrl+B X — Close pane.
    - Ctrl+B C — Create a new window.
    - Ctrl+B N or P — Move to the next or previous window.
    - Ctrl+B 0 (1,2...) — Move to a specific window by number.
    - Ctrl+B : — Enter the command line to type commands. Tab completion is available.
    - Ctrl+B ? — View all keybindings. Press Q to exit.
    - Ctrl+B W — Open a panel to navigate across windows in multiple sessions.


## On fresh systems:
- change hostname
- change preinstalled config: 
    - nix.settings.experimental-features = [ "nix-command" "flakes" ];
    - add git and openssh to system packages
    - activate ssh
        - programs.ssh.startAgent = true;
        - services.openssh.enable = true;
- manually copy ~/.ssh/id_ed25519
    - Assert directory owner / permission: 
        - sudo chown agl-admin:users -R ~/.ssh/
        - sudo chmod 700 -R ~/.ssh/
    - add to ssh-agent
        - ssh-add /home/agl-admin/.ssh/id_ed25519
- reboot

- manually copy ~/.config/sops/age/ directory

- manually copy hardware-configuration
- manually copy openvpn certs to ~/openvpn-cert/ 
- rebuild nixos: sudo nixos-rebuild switch
- reboot

## Git troubleshooting
Tell git which ssh config it should use
git config core.sshCommand "ssh -F ~/.ssh/config"

## SSH Troubleshooting
- make sure ssh file permissions are correct (owner: agl-admin:users ; mode: 700)
- add .ssh/id_ed25519 by running base-ssh-add (is a custom script)
- copy openvpn certificates to ~/openvpn-cert #
    - TODO: automate with sops

## Activate VSCode Server
- ln -sfT /run/current-system/etc/systemd/user/auto-fix-vscode-server.service ~/.config/systemd/user/auto-fix-vscode-server.service
- systemctl --user start auto-fix-vscode-server.service
- systemctl --user enable auto-fix-vscode-server.service
    - "The unit files have no installation config ..." can be ignored
- Enabling the user service creates a symlink to the Nix store, but the linked store path could be garbage collected at some point. One workaround to this particular issue is creating the following symlink:
    - ln -sfT /run/current-system/etc/systemd/user/auto-fix-vscode-server.service ~/.config/systemd/user/auto-fix-vscode-server.service

## Postgres
Manually set up passwords for users!

run
```bash
sudo -i -u postgres
psql

ALTER USER postgres PASSWORD 'pstgrsPWD';

```

## Keycloak
Make db user in postgresb:
```bash
ALTER USER keycloak PASSWORD 'kyclkPWD';

GRANT CONNECT ON DATABASE keycloak TO keycloak;
\c keycloak
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO keycloak;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO keycloak;
GRANT USAGE ON SCHEMA public TO keycloak;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO keycloak;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO keycloak;
```

Example Connect String:
'postgresql://postgres:newpassword@your_postgres_server_ip:5432/yourdatabase'

## BUGFIX nmd.tar.gz not available
Apparently https://rycee.net/ is not reachable from Russian IP addresses (tried several providers — there is just no response to the TCP connection to port 443, even though traceroute --icmp rycee.net can reach the server, and plain traceroute rycee.net reaches static.213-239-254-10.clients.your-server.de, which is the host just before the server in traceroute --icmp). It's not obvious which side blocks the HTTPS access.

If the file can be obtained through other means, you can use 

nix-prefetch-url --unpack --name source file:///home/agl-admin/nix-config/nmd.tar.gz

as a workaround for not having direct access. (File is available via git) 

## Add SHA Argument to tarball downloads:
### Find the SHA256 Hash:
You need to obtain the SHA256 hash of the tarball that you are trying to fetch. This can be done using nix-prefetch-url. Run the following command in your terminal:

'nix-prefetch-url --unpack "https://github.com/msteen/nixos-vscode-server/tarball/master"'

### Update Your Configuration:
Once you have the SHA256 hash, modify your NixOS configuration to include it in the fetchTarball function. Update your configuration as follows:

```nix
{ pkgs, ... }: let
    vscode-server = pkgs.fetchTarball {
        url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
        sha256 = "<insert-sha256-here>";  # Replace with actual hash
    };
in {
    imports = [
        "${vscode-server}/modules/vscode-server/home.nix"
    ];

    services.vscode-server.enable = true;
}

## Nvidia
see: https://nixos.wiki/wiki/Nvidia
sudo lshw -c display

```

