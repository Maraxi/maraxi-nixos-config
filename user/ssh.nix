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
        IdentityFile = "/home/stefan/.ssh/id_ed25519_raspberrypi";
      };
      "github.com" = {
        IdentityFile = "/home/stefan/.ssh/id_ed25519_github";
      };
      "codeberg.org" = {
        IdentityFile = "/home/stefan/.ssh/id_ed25519_codeberg";
      };
      "work" = {
        Hostname = "pc9d217";
        User = "iv546";
        IdentityFile = "/home/stefan/.ssh/id_ed25519_pc9d217";
      };
    };
  };
}
