{ pkgs, setup, ... }: {
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
      size = "32x32";
    };
    settings = {
      # See dunst(5) for all configuration options
      # Also see dotfiles/dunstrc
      global = {
        monitor = if setup.isNixOS then "DP-5" else "eDP-1-1";
        follow = "none";
        indicate_hidden = true;

        width = 300;
        height = "(0, 300)";
        origin = "top-right";
        offset = "(10, 30)";

        icon_corner_radius = 0;
        icon_corners = "all";

        separator_height = 1;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 2;
        frame_color = "#aaaaaa";
        gap_size = 0;

        idle_threshold = 120;

        font = "Monospace 9";
        line_height = 0;
        markup = "full";

        show_age_threshold = 60;
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;

        enable_recursive_icon_lookup = false;
        icon_theme = "Paprius, Humanity, Yaru, Adwaita, hicolor";

        corner_radius = 0;
        corners = "all";

        ignore_dbusclose = true;
      };
      urgency_low = {
        background = "#222222";
        foreground = "#888888";
        timeout = 10;
        default_icon = "dialog-information";
      };
      urgency_normal = {
        background = "#285577";
        foreground = "#ffffff";
        timeout = 10;
        default_icon = "dialog-information";
      };
      urgency_critical = {
        background = "#580ef7";
        foreground = "#ffffff";
        timeout = 0;
        default_icon = "dialog-warning";
      };
      teams-timeout-override = {
        body = "*teams.microsoft.com*";
        urgency = "normal";
        timeout = 12;
        # Overwrite settings from dbus, this would take priority over the normal timeout
        override_dbus_timeout = 12;
        # 1. Force a static icon (fixes the shifting /tmp path issue)
        new_icon = "dialog-information";
      };
    };
  };
}
