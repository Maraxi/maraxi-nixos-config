{pkgs, ...}: {
  home.shellAliases = {
    cal = "ncal -b3A3";
  };
  programs.bash.enable = true;
  programs.readline = {
    enable = true;
    variables = {
      colored-stats = true;
      completion-ignore-case = true;
      completion-prefix-display-length = 3;
      mark-symlinked-directories = true;
      match-hidden-files = true;
      show-all-if-ambiguous = true;
      show-all-if-unmodified = true;
      visible-stats = true;
    };
  };
  programs.nushell = {
    enable = true;
    # for editing directly to config.nu
    extraConfig = ''
      # let carapace_completer = {|spans|
      # carapace $spans.0 nushell $spans | from json
      # }
      $env.config = {
       show_banner: false,
       # completions: {
       # case_sensitive: false # case-sensitive completions
       # quick: true    # set to false to prevent auto-selecting completions
       # partial: true    # set to false to prevent partial filling of the prompt
       # algorithm: "fuzzy"    # prefix or fuzzy
       # external: {
       # set to false to prevent nushell looking into $env.PATH to find more suggestions
           # enable: true
       # set to lower can improve completion performance at the cost of omitting some options
           # max_results: 100
           # completer: $carapace_completer # check 'carapace_completer'
         # }
       # }
      }
      # $env.PATH = ($env.PATH |
      # split row (char esep) |
      # prepend /home/myuser/.apps |
      # append /usr/bin/env
      # )
    '';
    # shellAliases = {
    # vi = "hx";
    # vim = "hx";
    # nano = "hx";
    # };
  };
  # programs.carapace = {
  # enable = true;
  # enableNushellIntegration = true;
  # };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = ["--cmd" "cd"];
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.eza = {
    enable = true;
    icons = true;
    extraOptions = [
      "--group-directories-first"
    ];
    package = pkgs.eza;
  };
}
