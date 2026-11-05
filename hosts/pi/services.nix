{ lib, ... }:
{
  imports = [ ../../system/home-assistant.nix ];

  # disabled on the pi for now
  services.home-assistant.enable = lib.mkForce false;

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
