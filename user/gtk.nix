{ config, pkgs, ... }:
let
  cursor = {
    package = pkgs.volantes-cursors;
    name = "volantes_cursors";
  };
  cat-variant = "mocha";
  cat-accents = "mauve";
  cat-size = "standard";
  iconThemeName = "Papirus-Dark-Fallback";
in
{
  # GTK only takes a single icon theme name, so use an empty theme that inherits
  # Papirus-Dark and falls back to other themes for icons Papirus lacks.
  xdg.dataFile."icons/${iconThemeName}/index.theme".text = ''
    [Icon Theme]
    Name=${iconThemeName}
    Comment=Papirus-Dark with Yaru and Adwaita fallbacks
    Inherits=Papirus-Dark,Yaru,Adwaita,hicolor
    Directories=
  '';

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    dotIcons.enable = false;
  }
  // cursor;

  # Keep the files of the gtk2 and x11 cursor config out of ~ (XDG Base Directory)
  xresources.path = "${config.xdg.configHome}/X11/Xresources";

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    theme = {
      package = pkgs.catppuccin-gtk.override {
        variant = cat-variant;
        accents = [ cat-accents ];
        size = cat-size;
      };
      name = "catppuccin-${cat-variant}-${cat-accents}-${cat-size}";
    };
    iconTheme = {
      # nixpkgs' dropIconThemeCache hook deletes the icon-theme.cache that the
      # build creates, which makes every GTK app scan thousands of icon
      # directories at startup (~1s). Keep the cache.
      package =
        (pkgs.catppuccin-papirus-folders.override {
          flavor = cat-variant;
          accent = cat-accents;
        }).overrideAttrs
          (_: {
            dontDropIconThemeCache = true;
          });
      name = iconThemeName;
    };
    cursorTheme = cursor;

    # remove the legacy config gtk-application-prefer-dark
    # should be covered by the dconf entry org.gnome.desktop.interface color-scheme
    # gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    # gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;

    gtk4.theme = null; # do not force GTK3 themes to GTK4 apps
  };
}
