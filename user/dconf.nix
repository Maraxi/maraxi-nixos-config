{
  keyboard,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.dconf-editor ];
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.gvariant.mkTuple [
          "xkb"
          (if keyboard.variant == "" then keyboard.layout else "${keyboard.layout}+${keyboard.variant}")
        ])
      ];
      xkb-options = keyboard.options;
    };
    "org/gnome/shell/extensions/ding" = {
      show-home = false;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      rotate-video-lock-static = [ "XF86RotationLockToggle" ]; # Remove `<Super>o` from this bind to free it for screensaver
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
  };
}
