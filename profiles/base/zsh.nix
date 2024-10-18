{ pkgs, ...}@inputs:
{

    users.defaultUserShell = pkgs.zsh;
    users.users.agl-admin.useDefaultShell = true;

    environment.systemPackages = with pkgs; [
        zsh
        zsh-autosuggestions
        zsh-syntax-highlighting
        zsh-completions
        zsh-history-substring-search
        # zsh-lovers
        # zsh-navigation-tools
        # zsh-pure
    ];

    programs = inputs.agl-network-config.service-configs.zsh;

}