{ lib, setup, ... }:
let
  # Alias names are "l" + scope + topo + files + short, e.g. "lgtfs".
  # Each key is the letter appended to the name, each value the arguments it adds to `git l`,
  # with a leading space.
  scopeOptions = {
    "" = "";
    g = " origin/HEAD";
    a = " --branches --remotes";
    x =
      " --exclude master --exclude main --exclude release-candiate --branches"
      + " --exclude *master --exclude *main --exclude *release-candiate --exclude *dependabot* --exclude */renovate/* --remotes";
  };
  topoOptions = {
    "" = "";
    t = " --topo-order";
  };
  filesOptions = {
    "" = "";
    f = " --name-status";
  };
  shortOptions = {
    "" = "";
    s = " -n 30";
  };

  combinations = lib.cartesianProduct {
    scope = builtins.attrNames scopeOptions;
    topo = builtins.attrNames topoOptions;
    files = builtins.attrNames filesOptions;
    short = builtins.attrNames shortOptions;
  };

  logAlias =
    {
      scope,
      topo,
      files,
      short,
    }:
    {
      name = "l${scope}${topo}${files}${short}";
      value = "l${scopeOptions.${scope}}${topoOptions.${topo}}${filesOptions.${files}}${shortOptions.${short}}";
    };

  # "l" itself is the base alias
  logAliases = removeAttrs (lib.listToAttrs (map logAlias combinations)) [ "l" ];
in
{
  home.shellAliases = {
    gti = "git";
    s = "git status";
    g = "git lgs";
    l = "git ls";
  };
  programs.git = {
    enable = true;
    settings = {
      user =
        if setup.isNixOS then
          {
            name = "Maraxi";
            email = "Maraxi@users.noreply.github.com";
          }
        else
          { };
      alias = {
        aliases = "config --get-regexp alias";

        root = "rev-parse --show-toplevel";

        update-origin-head = "remote set-head origin -a";
        # switch to the remote's default branch and reset it to match origin
        default = ''!f() { ref=$(git symbolic-ref --short refs/remotes/origin/HEAD) && git switch -C "''${ref#origin/}" "$ref"; }; f'';

        unstage = "reset HEAD --";
        s = "status";

        d = "diff";
        diffs = "diff --staged";
        ds = "diffs";

        p = "add -p";
        cm = "commit -m";
        amend = "commit --amend -C HEAD";

        rebase-continue = "-c core.editor=true rebase --continue";

        ls-untracked = "ls-files --others --exclude-standard --directory";
        ls-ignored = "ls-files --others --ignored --exclude-standard --directory";

        l =
          "log --graph --date-order --date=human"
          # space before %h for delta pager, its parser does not find the link otherwise
          + " --format='%C(bold blue) %h%C(reset) %C(bold green)(%cd)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%(decorate:tag=)%C(reset)'"
          + " --tags HEAD";
      }
      # l[g|a|x][f][s] generated from the parts above, see `git aliases`
      // logAliases;

      pager = lib.genAttrs (builtins.filter (lib.hasInfix "f") (builtins.attrNames logAliases)) (
        # Git inserts an extra new line after each commit for extra separation.
        # Delete this line for the file listing aliases with `sed`.
        # Only matches lines that contain ANSI color codes, spaces and vertical bar and delete them.
        _: "sed -E '/^(\\x1b\\[[0-9;]*m|[| ])+$/d' | less"
      );
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
      line-numbers = true;
      line-numbers-zero-style = "#707070";
      navigate = true;
      # side-by-side = true;
      tabs = 4;
      map-styles =
        let
          git-moved-from-color = "bold purple";
          git-moved-to-color = "bold cyan";
        in
        "${git-moved-from-color} => syntax #3f2054, ${git-moved-to-color} => auto #132852";
    };
  };
}
