{
  home.shellAliases = {
    s = "git status";
    g = "git lgs";
  };
  programs.git = {
    enable = true;
    userName = "Maraxi";
    userEmail = "Maraxi@users.noreply.github.com";
    aliases = let
      formatted-log = "log --graph --abbrev-commit --date-order --date=relative --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%cd)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --tags HEAD";
    in {
      aliases = "config --get-regexp alias";

      root = "rev-parse --show-toplevel";

      unstage = "reset HEAD --";
      s = "status";

      d = "diff";
      diffs = "diff --staged";
      ds = "diffs";

      p = "add -p";
      cm = "commit -m";
      amend = "commit --amend -C HEAD";

      pushd = "push -u origin HEAD";

      lg = "${formatted-log} --branches --remotes";
      lgs = "lg -n 20";

      lgx = "${formatted-log} --exclude master --exclude main --exclude release-candiate --branches --exclude *master --exclude *main --exclude *release-candiate --exclude *HEAD --remotes";
      lgxs = "lgx -n 20";

      lgf = "lg --name-status";
      lgfs = "lgf -n 20";
    };
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";
      fetch = {
        prune = true;
        pruneTags = true;
      };
    };
    diff-so-fancy.enable = true;
  };
}
