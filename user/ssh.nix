{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        compression = true;
      };
      "pi" = {
        hostname = "raspberrypi";
        user = "stefan";
        port = 36969;
        identityFile = "/home/stefan/.ssh/id_ed25519_raspberrypi";
      };
      "github.com" = {
        identityFile = "/home/stefan/.ssh/id_ed25519_github";
      };
      "codeberg.org" = {
        identityFile = "/home/stefan/.ssh/id_ed25519_codeberg";
      };
    };
  };
}
