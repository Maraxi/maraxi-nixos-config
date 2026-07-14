{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.mpv];
  xdg.configFile."mpv/scripts/custom-status.lua".source = config.lib.meta.mkMutableSymlink dotfiles/mpv/custom-status.lua;
  # ~/bin/detektor already available from environment.nix
}
