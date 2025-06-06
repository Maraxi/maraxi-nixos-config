{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "esphome"
      "met"
      "miele"
      "radio_browser"
      "shelly"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
  };
}
