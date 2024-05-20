{}: {
  programs.git = {
    enable = true;
    userName = "Maraxi";
    userEmail = "Maraxi@users.noreply.github.com";
    aliases = {
      s = "status";
      p = "add -p";
      cm = "commit -m";
    };
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
