{...}: {
  home.shellAliases = {
    s = "git status";
    g = "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' -n5";
  };
  programs.git = {
    enable = true;
    userName = "Maraxi";
    userEmail = "Maraxi@users.noreply.github.com";
    aliases = {
      aliases = "config --get-regexp alias";
      pushd = "push -u origin HEAD";
      s = "status";
      p = "add -p";
      cm = "commit -m";
      lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --branches --remotes --tags HEAD";
      lgs = "lg -n 15";
    };
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
