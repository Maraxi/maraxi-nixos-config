{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  services.gvfs.enable = true; # userspace virtual filesystem
  services.udisks2.enable = true; # DBus service for applications to query storage devices

  # automount / unmount drives
  # services.devmon.enable = true; # automatic mounting of drives
  # Do not run devmon in the greetd greeter session.
  # systemd.user.services.devmon.unitConfig.ConditionUser = "!greeter";
}
