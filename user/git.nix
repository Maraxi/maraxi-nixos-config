{setup, ...}: {
  home.shellAliases = {
    s = "git status";
    g = "git lgs";
    l = "git ls";
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
      alias = {
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

        ls-tracked = "ls-tree -r HEAD --name-only";
        ls-untracked = "ls-files --others --exclude-standard --directory";
        ls-ignored = "ls-files --others --ignored --exclude-standard --directory";

        # using tformat intead of format does not quite fix the lf alias, there is still an extra empty line
        l =
          "log --graph --date-order --date=human"
          # space before %h for delta pager, its parser does not find the link otherwise
          + " --format=tformat:'%C(bold blue) %h%C(reset) %C(bold green)(%cd)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%(decorate:tag=)%C(reset)'"
          + " --tags HEAD";
        ls = "l -n 30";

        lg = "l --branches --remotes";
        lgs = "lg -n 30";

        lgx =
          "l"
          + " --exclude master --exclude main --exclude release-candiate --branches"
          + " --exclude *master --exclude *main --exclude *release-candiate --exclude *dependabot* --remotes";
        lgxs = "lgx -n 30";

        lf = "l --name-status";
        lfs = "lf -n 30";

        lgf = "lg --name-status";
        lgfs = "lgf -n 30";
      };
      core.editor = "nvim";
      diff.colorMoved = "default";
      fetch.prune = true;
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
    };
    signing.format = null;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      hunk-header-style = "omit";
      hyperlinks = true;
      hyperlinks-file-link-format = "nvim://open?file={path}&line={line}";
      line-numbers-zero-style = "#707070";
      navigate = true;
      side-by-side = true;
      tabs = 4;
    };
  };
}
