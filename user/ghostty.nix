{ config, mutableLink, ... }: {
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    enableBashIntegration = true;
  };

  xdg.configFile = {
    "ghostty/config" = mutableLink dotfiles/ghostty/config;
    "ghostty/themes" = mutableLink dotfiles/ghostty/themes;
    # The home-manager unit is only linked, not enabled, so it would start on the first D-Bus request.
    # Wanting it from the graphical session starts it on login.
    "systemd/user/graphical-session.target.wants/app-com.mitchellh.ghostty.service".source =
      "${config.programs.ghostty.package}/share/systemd/user/app-com.mitchellh.ghostty.service";
  };
}
