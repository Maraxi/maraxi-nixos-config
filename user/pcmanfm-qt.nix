# pcmanfm-qt is the file manager. Unlike Thunar it does not stat every file individually on smb://.
{
  lib,
  mutableLink,
  pkgs,
  setup,
  ...
}:
{
  home.packages = [
    # The gtk3 platform theme makes Qt take icon theme, colors and font from the GTK settings (gtk.nix), so it
    # matches the rest of the desktop.
    (pkgs.symlinkJoin {
      name = "pcmanfm-qt-wrapped";
      paths = [ pkgs.pcmanfm-qt ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = "wrapProgram $out/bin/pcmanfm-qt --set QT_QPA_PLATFORMTHEME gtk3";
      meta.mainProgram = "pcmanfm-qt";
    })
  ];

  # The app writes its settings (window size, view mode, ...) back through this link.
  xdg.configFile."pcmanfm-qt/default/settings.conf" = mutableLink dotfiles/pcmanfm-qt/settings.conf;

  # smb://, sftp://, ... need the gvfs GIO module that matches nix's glib. Only the client module is
  # used, the gvfs daemons are Ubuntu's (activated via dbus). NixOS provides all of this through services.gvfs.
  home.sessionVariables = lib.mkIf (!setup.isNixOS) {
    GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
  };
}
