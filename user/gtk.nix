{ pkgs, ... }:
let
  cursor = {
    package = pkgs.volantes-cursors;
    name = "volantes_cursors";
  };
  cat-variant = "mocha";
  cat-accents = "mauve";
  cat-size = "standard";
in
{
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    dotIcons.enable = false;
  }
  // cursor;
  gtk = {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk.override {
        variant = cat-variant;
        accents = [ cat-accents ];
        size = cat-size;
      };
      name = "catppuccin-${cat-variant}-${cat-accents}-${cat-size}";
    };
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = cat-variant;
        accent = cat-accents;
      };
      name = "Papirus-Dark";
    };
    cursorTheme = cursor;

    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;

    gtk4.theme = null;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
}
