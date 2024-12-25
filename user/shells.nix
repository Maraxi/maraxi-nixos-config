{pkgs, ...}: {
  programs.bash = {
    enable = true;

    historySize = -1;
    historyFileSize = -1;
    historyFile = "$HOME/.bash_history_eternal";
    historyControl = ["ignorespace" "ignoredups"];

    initExtra = ''
      bind -x '"\C-o":${pkgs.ruff}/bin/ruff format; ${pkgs.ruff}/bin/ruff check --fix --unsafe-fixes'
      bind -x '"\C-p":${pkgs.pre-commit}/bin/pre-commit'

      export HISTTIMEFORMAT="[%F %T] "
      PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
    '';
  };
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
      #   carapace $spans.0 nushell $spans | from json
      # }
      $env.config = {
       show_banner: false,
       # completions: {
       #   case_sensitive: false # case-sensitive completions
       #   quick: true    # set to false to prevent auto-selecting completions
       #   partial: true    # set to false to prevent partial filling of the prompt
       #   algorithm: "fuzzy"    # prefix or fuzzy
       #   external: {
       #     set to false to prevent nushell looking into $env.PATH to find more suggestions
       #     enable: true
       #     set to lower can improve completion performance at the cost of omitting some options
       #     max_results: 100
       #     completer: $carapace_completer # check 'carapace_completer'
       #   }
       # }
      }
      # $env.PATH = ($env.PATH |
      # split row (char esep) |
      # prepend /home/myuser/.apps |
      # append /usr/bin/env
      # )
    '';
    # shellAliases = {
    #   nano = "hx";
    # };
  };
  # programs.carapace = { # command line completions
  #   enable = true;
  #   enableNushellIntegration = true;
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
  xdg.configFile."starship.toml".source = dotfiles/starship.toml;

  programs.eza = {
    enable = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--classify"
    ];
  };
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--max-columns-preview"
      "--max-columns=100"
    ];
  };
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = {
      global.strict_env = true;
    };
  };

  programs.lesspipe.enable = true;

  xdg.configFile = {
    "lesskey".source = dotfiles/lesskey;
    "ghostty" = {
      source = dotfiles/ghostty;
      recursive = true;
    };
  };
}
