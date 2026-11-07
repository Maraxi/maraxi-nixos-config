{
  keyboard,
  lib,
  locale,
  ...
}:
{
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = locale;

  # Configure keymap in X11
  services.xserver.xkb = keyboard // {
    options = lib.concatStringsSep "," keyboard.options;
  };
  console.useXkbConfig = true; # use xkb.options in tty.
}
