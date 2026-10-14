{ pkgs, mutableLink, ... }: {
  home.packages = [ pkgs.mpv ];
  xdg.configFile."mpv/scripts/custom-status.lua" = mutableLink dotfiles/mpv/custom-status.lua;
  # ~/bin/detektor already available from environment.nix
}
