{setup, ...}: {
  home.shellAliases = {
    s = "git status";
    g = "git lgs";
  };
  programs.git = {
    enable = true;
    settings = {
      user =
        if setup.isNixOS
        then {
          name = "Maraxi";
          email = "Maraxi@users.noreply.github.com";
        }
        else {};
      alias = let
        formatted-log = "log --graph --abbrev-commit --topo-order --date=relative --decorate --format=format:'%C(bold blue)%h%C(reset) %C(bold green)(%cd)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --tags HEAD";
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

        rebase-continue = "-c core.editor=true rebase --continue";
        rebase-with-dates = "rebase --committer-date-is-author-date";

        lg = "${formatted-log} --branches --remotes";
        lgs = "lg -n 20";

        lgx = "${formatted-log} --exclude master --exclude main --exclude release-candiate --branches --exclude *master --exclude *main --exclude *release-candiate --remotes";
        lgxs = "lgx -n 20";

        lgf = "lg --name-status";
        lgfs = "lgf -n 20";
      };
      core.editor = "nvim";
      fetch.prune = true;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
    };
  };

  programs.diff-so-fancy = {
    enable = true;
    settings.rulerWidth = 60;
    enableGitIntegration = true;
  };
}
