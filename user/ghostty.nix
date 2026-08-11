{ config, ... }: {
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    enableBashIntegration = true;
  };

  xdg.configFile."ghostty".source = config.lib.meta.mkMutableSymlink dotfiles/ghostty;
}
