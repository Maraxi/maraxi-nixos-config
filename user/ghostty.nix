{ config, setup, ... }: {
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    enableBashIntegration = true;
  };

  xdg.configFile = {
    "ghostty/config".source = config.lib.meta.mkMutableSymlink dotfiles/ghostty/config;
    "ghostty/themes".source = config.lib.meta.mkMutableSymlink dotfiles/ghostty/themes;
  }
  // (if setup.isNixOS then { } else { "ghostty/config.local".text = "background-opacity = 0.85"; });
}
