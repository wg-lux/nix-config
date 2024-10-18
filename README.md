# AglNet - Nix Configuration

## Custom Scripts
- setup-custom-log-dir
- openvpn-custom-log
- clear-custom-logs

## Custom Services
### Logging
#### openvpn-aglNet-custom-logger

## Configurations

### Shell
We use zsh + ohMyZsh. Shell Aliases and plugins are defined in `network-configuration/custom-services/zsh.nix`.

### Direnv
Requires interactiveShellInt:
Example for bash: `eval "$(direnv hook bash)"`
Example for zsh: `eval "$(direnv hook zsh)"`

