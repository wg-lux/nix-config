{ pkgs, ... }:
let
  tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-super-fingers";
      version = "unstable-2023-01-06";
      src = pkgs.fetchFromGitHub {
        owner = "artemave";
        repo = "tmux_super_fingers";
        rev = "2c12044984124e74e21a5a87d00f844083e4bdf7";
        sha256 = "sha256-cPZCV8xk9QpU49/7H8iGhQYK6JwWjviL29eWabuqruc=";
      };
    };
in
{
  home.packages = with pkgs; [
    tmux
    # tmuxPlugins.better-mouse-mode
    tmuxPlugins.catppuccin
    tmuxPlugins.resurrect
    tmuxPlugins.continuum
    tmuxp
  ];

    

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    # terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = with pkgs;
      [
        # {
        #   plugin = tmux-super-fingers;
        #   extraConfig = "set -g @super-fingers-key f";
        # }
        # # tmuxPlugins.better-mouse-mode
        # {
        #     plugin = tmuxPlugins.catppuccin;
        #     extraConfig = '' 
        #     set -g @catppuccin_flavour 'frappe'
        #     set -g @catppuccin_window_tabs_enabled on
        #     set -g @catppuccin_date_time "%H:%M"
        #     '';
        # }
        # {
        #     plugin = tmuxPlugins.resurrect;
        #     extraConfig = ''
        #     set -g @resurrect-strategy-vim 'session'
        #     set -g @resurrect-strategy-nvim 'session'
        #     set -g @resurrect-capture-pane-contents 'on'
        #     '';
        # }
        # {
        #     plugin = tmuxPlugins.continuum;
        #     extraConfig = ''
        #     set -g @continuum-restore 'on'
        #     set -g @continuum-boot 'on'
        #     set -g @continuum-save-interval '10'
        #     '';
        # }
      ];
    extraConfig = ''
      # change the prefix from 'C-b' to 'C-a'
      # (remap capslock to CTRL for easy access)
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix

      # start with window 1 (instead of 0)
      set -g base-index 1

      # start with pane 1
      set -g pane-base-index 1

      # split panes using | and -, make sure they open in the same path
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      unbind '"'
      unbind %

      # open new windows in the current path
      bind c new-window -c "#{pane_current_path}"

      # reload config file
      bind r source-file ~/.tmux.conf

      unbind p
      bind p previous-window

      # shorten command delay
      set -sg escape-time 1

      # don't rename windows automatically
      set -g allow-rename off

      # mouse control (clickable windows, panes, resizable panes)
      set -g mouse on

      # enable vi mode keys
      set-window-option -g mode-keys vi

      # set default terminal mode to 256 colors
      # set -g default-terminal "xterm-256color"
      # set -ga terminal-overrides ",xterm-256color:Tc"

      # present a menu of URLs to open from the visible pane. sweet.
      bind u capture-pane \;\
          save-buffer /tmp/tmux-buffer \;\
          split-window -l 10 "urlview /tmp/tmux-buffer"


      ######################
      ### DESIGN CHANGES ###
      ######################

      # loud or quiet?
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      #  modes
      setw -g clock-mode-colour colour1
      setw -g mode-style 'fg=colour0 bg=colour1 bold'

      # panes
      set -g pane-border-style 'fg=colour1'
      set -g pane-active-border-style 'fg=colour3'

      # statusbar
      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'fg=colour1'
      set -g status-left ""
      set -g status-right '%Y-%m-%d %H:%M '
      set -g status-right-length 50
      set -g status-left-length 10

      setw -g window-status-current-style 'fg=colour0 bg=colour1 bold'
      setw -g window-status-current-format ' #I #W #F '

      setw -g window-status-style 'fg=colour1 dim'
      setw -g window-status-format ' #I #[fg=colour7]#W #[fg=colour1]#F '

      setw -g window-status-bell-style 'fg=colour2 bg=colour1 bold'

      # messages
      set -g message-style 'fg=colour2 bg=colour0 bold'

    '';
  };
}
