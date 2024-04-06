{pkgs}:
# add like this
# environment.systemPackages = [
#     # .....
#     (import .services/endoreg-client/dev-mode.nix {inherit pkgs;})
# ];
pkgs.writeShellScriptBin "erc-dev" ''
#!${pkgs.zsh}/bin/zsh
sudo systemctl stop endoreg-client-manager
echo "Stopped endoreg-client-manager"

sudo systemctl stop endoreg-client-manager-celery
echo "Stopped endoreg-client-manager-celery"

sudo systemctl stop endoreg-client-manager-celery-beat
echo "Stopped endoreg-client-manager-celery-beat"

sudo mountDropOff
echo "Mounted dropoff"

sudo mountPseudo
echo "Mounted pseudo"

sudo mountProcessed
echo "Mounted processed"
''