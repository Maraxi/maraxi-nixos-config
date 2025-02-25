{...}: {
  programs.ghostty.enable = false;

  xdg.configFile = {
    "ghostty" = {
      source = dotfiles/ghostty;
      recursive = true;
    };
  };
}
