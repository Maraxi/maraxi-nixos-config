{ pkgs, mutableLink, ... }:
let
  # Linked to ~/.local/share/tmux/plugins/<name> so tmux.conf can use stable paths
  plugins = with pkgs.tmuxPlugins; [
    sensible
    resurrect
    continuum
  ];
in
{
  home.packages = [ pkgs.tmux ];

  xdg.configFile."tmux/tmux.conf" = mutableLink dotfiles/tmux/tmux.conf;

  xdg.dataFile = builtins.listToAttrs (
    map (p: {
      name = "tmux/plugins/${p.pluginName}";
      value.source = "${p}/share/tmux-plugins/${p.pluginName}";
    }) plugins
  );
}
