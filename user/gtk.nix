{pkgs, ...}: let
  cursor = {
    package = pkgs.volantes-cursors;
    name = "volantes_cursors";
  };
in {
  home.pointerCursor =
    cursor
    // {
      gtk.enable = true;
      x11.enable = true;
      dotIcons.enable = false;
    };
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      # name = "Dracula";
      # package = pkgs.dracula-icon-theme;
      # name = "Material-Black-Plum-Suru";
      name = "MB-Plum-Suru-GLOW";
      package = pkgs.material-black-colors;
    };
    cursorTheme = cursor;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4 = {
      theme = null;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
