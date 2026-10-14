{ setup, mutableLink, ... }: {
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    enableBashIntegration = true;
  };

  xdg.configFile = {
    "ghostty/config" = mutableLink dotfiles/ghostty/config;
    "ghostty/themes" = mutableLink dotfiles/ghostty/themes;
  }
  // (if setup.isNixOS then { } else { "ghostty/config.local".text = "background-opacity = 0.85"; });
}
