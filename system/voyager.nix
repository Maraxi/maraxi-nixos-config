{pkgs, ...}: {
  # udev rules for voyager keyboard
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
  '';
  environment.systemPackages = [pkgs.keymapp];
}
