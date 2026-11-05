{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        Compression = true;
      };
      "pi" = {
        Hostname = "raspberrypi";
        User = "stefan";
        Port = 36969;
        IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519_raspberrypi";
      };
      "github.com" = {
        IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519_github";
      };
      "codeberg.org" = {
        IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519_codeberg";
      };
      "work" = {
        Hostname = "pc9d217";
        User = "iv546_local";
        IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519_pc9d217";
      };
    };
  };
}
