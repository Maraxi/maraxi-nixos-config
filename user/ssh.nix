{
  programs.ssh = {
    enable = true;
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
    };
  };
}
