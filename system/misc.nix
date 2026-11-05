{
  # wayland-related
  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  programs.dconf.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    # pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };
  # services.dbus.packages = [ pkgs.gcr ];
  # services.pcscd.enable = true;

  # Packages are listed both via the system path and on their own in the D-Bus config, so dbus-broker logs an
  # "Ignoring duplicate name" line for each service file on every boot. Harmless, only filter it from the journal.
  # The user bus logs as user@<uid>.service, the template covers every user.
  systemd.services = {
    dbus-broker.serviceConfig.LogFilterPatterns = "~Ignoring duplicate name";
    "user@".serviceConfig.LogFilterPatterns = "~Ignoring duplicate name";
  };
}
