{pkgs, ...}: {
  home.pointerCursor = {
    name = "volantes_cursors";
    package = pkgs.volantes-cursors;
    gtk.enable = true;
    x11.enable = true;
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
    cursorTheme = {
      name = "volantes_cursors";
      package = pkgs.volantes-cursors;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
