{ lib, setup, ... }: {
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.gvariant.mkTuple [
          "xkb"
          "de+nodeadkeys"
        ])
      ];
      xkb-options = [ "caps:escape" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = [ "<Super>o" ];
      terminal = [ "<Super>Return" ];
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };
    "org/gnome/desktop/interface" = {
      gtk-enable-primary-paste = true;
      color-scheme = "prefer-dark";
    };
    "org/nemo/preferences" = {
      show-hidden-files = true;
      thumbnail-limit = lib.hm.gvariant.mkUint64 1073741824;
    };
    "org/cinnamon/desktop/applications/terminal" = {
      exec =
        if setup.isNixOS then
          "ghostty --working-directory=inherit" # for nemo -> open in terminal
        else
          "alacritty";
    };
  };
}
