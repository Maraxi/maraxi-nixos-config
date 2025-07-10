{
  setup,
  lib,
  config,
  ...
}: {
  programs.bash = {
    enable = true;

    historySize = -1;
    historyFileSize = -1;
    historyFile = "$XDG_STATE_HOME/bash_history_eternal";
    historyControl = ["ignorespace" "ignoredups"];

    shellAliases =
      {feh = "feh --no-fehbg";}
      // lib.optionalAttrs setup.isNixOS {cal = "cal -Sn9";};

    sessionVariables = {
      HISTTIMEFORMAT = "[%F %T] ";
      PROMPT_COMMAND = "history -a; $PROMPT_COMMAND";
      _ZO_DOCTOR = 0;
    };

    initExtra = let
      profile-bin = config.home.profileDirectory + "/bin";
      check-git = "git rev-parse --is-inside-work-tree &>/dev/null";
    in
      lib.mkOrder 100 ''
        bind -x '"\C-o":${check-git} && { ${profile-bin}/ruff format; ${profile-bin}/ruff check --fix --unsafe-fixes; }'
        bind -x '"\C-p":${check-git} && ${profile-bin}/pre-commit'

        stty -ixon
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
  xdg.configFile."starship.toml".source = config.lib.meta.mkMutableSymlink dotfiles/starship.toml;

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
      "--max-columns=200"
      "--follow"
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
  xdg.configFile."lesskey".source = dotfiles/lesskey;

  xdg.dataFile."ipython/profile_default/ipython_config.py".text = ''
    c = get_config()
    c.TerminalInteractiveShell.confirm_exit = False
  '';
}
