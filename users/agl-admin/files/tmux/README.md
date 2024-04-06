Load tmux sessions via json and YAML, tmuxinator and teamocil style.

Example file: ./example.yaml

load:
tmuxp load ./example.yaml

Projects with .tmuxp.yaml or .tmuxp.json load via directory:
tmuxp load path/to/my/project/

Load multiple at once (in bg, offer to attach last):
tmuxp load mysession ./another/project/

Name a session:
tmuxp load -s session_name ./mysession.yaml
simple and very elaborate config examples


### Configuration
tmuxp checks for configs in user directories:
$TMUXP_CONFIGDIR, if set

$XDG_CONFIG_HOME, usually $HOME/.config/tmuxp/
$HOME/.tmuxp/

Load your tmuxp config from anywhere by using the filename, assuming ~/.config/tmuxp/mysession.yaml (or .json):

tmuxp load mysession
See author’s tmuxp configs and the projects’ tmuxp.yaml.

