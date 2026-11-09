# Thunar comes from nixpkgs, so its helpers have to be reachable without a NixOS desktop module.
{
  lib,
  mutableLink,
  pkgs,
  setup,
  ...
}:
{
  home.packages = with pkgs; [
    thunar
    tumbler # thumbnails
    xfconf # settings backend (dbus service)
  ];

  xdg.configFile."Thunar/uca.xml" = mutableLink dotfiles/thunar/uca.xml;

  # The dbus service file of tumbler has SystemdService=tumblerd.service, but systemd does not search the
  # nix profile for units. Without a unit the activation fails and Thunar shows no thumbnails.
  systemd.user.services.tumblerd = {
    Unit.Description = "Thumbnailing service";
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.thumbnails.Thumbnailer1";
      ExecStart = "${pkgs.tumbler}/lib/tumbler-1/tumblerd";
    };
  };

  # Same issue for xfconf (SystemdService=xfconfd.service). Without the daemon Thunar cannot persist its
  # settings (toolbar, view, ...) and they reset on every start.
  systemd.user.services.xfconfd = {
    Unit.Description = "Xfce configuration storage service";
    Service = {
      Type = "dbus";
      BusName = "org.xfce.Xfconf";
      ExecStart = "${pkgs.xfconf}/lib/xfce4/xfconf/xfconfd";
    };
  };

  # smb://, sftp://, ... in Thunar need the gvfs GIO module that matches nix's glib. Only the client module is
  # used, the gvfs daemons are Ubuntu's (activated via dbus). NixOS provides all of this through services.gvfs.
  home.sessionVariables = lib.mkIf (!setup.isNixOS) {
    GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
  };
}
