{
  # wayland-related
  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;

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
}
