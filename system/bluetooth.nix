{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    # The kernel has no ISO sockets, so LE Audio (BAP) cannot work and only logs errors on every start.
    disabledPlugins = [ "bap" ];
    settings = {
      General = {
        # Shows battery charge of connected devices on supported Bluetooth adapters.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found.
        # This includes adapters present on start as well as adapters that are plugged in later on.
        # AutoEnable = true;
      };
    };
  };
}
