{
  services.home-assistant = {
    enable = false;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      # Integrations
      "shelly"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
  };

  # As of Home Assistant 2023.12.0 many components started depending on the matter integration
  # It unfortunately still relies on OpenSSL 1.1, which has gone end of life in 2023/09
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  # paperless
  services.paperless = {
    enable = false;
    # address = "0.0.0.0";
    # port = 58080;
    settings = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };
}
