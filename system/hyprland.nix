{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Enabled by default by graphical-desktop.nix, pulls in mbrola-voices (~650 MiB). Not used.
  services.speechd.enable = false;
}
