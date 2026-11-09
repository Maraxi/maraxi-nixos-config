{ pkgs, mutableLink, ... }: {
  home.packages = [ (pkgs.mpv.override { youtubeSupport = false; }) ];
  xdg.configFile."mpv/scripts/custom-status.lua" = mutableLink dotfiles/mpv/custom-status.lua;
  # ~/.local/bin/detektor is linked by environment.nix
}
