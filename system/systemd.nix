{
  services.logind.settings.Login = {
    # required since shokz usb controller sends a poweroff signal
    HandlePowerKey = "ignore";
    # PowerKeyIgnoreInhibited = "yes";
  };
}
