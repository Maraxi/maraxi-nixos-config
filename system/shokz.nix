{ pkgs, ... }: {
  # udev rules to disable input from shokz usb receiver
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="3511", ATTRS{idProduct}=="2ef2", DRIVER=="usbhid", ATTR{authorized}="0"
  '';
}
