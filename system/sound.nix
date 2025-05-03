{
  # Enable sound.
  # sound.enable = false;
  security.rtkit.enable = true; # RealtimeKit
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
}
