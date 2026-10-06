{ lib, pkgs, ... }: {
  home.packages = [ pkgs.dconf-editor ];
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
    "org/gnome/shell/extensions/ding" = {
      show-home = false;
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
      thumbnail-limit = lib.hm.gvariant.mkUint64 1073741824; # 2^30 bytes = 1 GiB
    };
    "org/cinnamon/desktop/applications/terminal" = {
      # for nemo -> open in terminal
      exec = "ghostty --working-directory=inherit";
    };
  };
}
