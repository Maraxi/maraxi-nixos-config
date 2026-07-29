{
  lib,
  config,
  setup,
  ...
}: {
  programs.bash = {
    enable = true;

    historySize = -1;
    historyFileSize = -1;
    historyFile = "$XDG_STATE_HOME/bash_history_eternal";
    historyControl = ["ignorespace" "ignoredups"];

    sessionVariables = {
      HISTTIMEFORMAT = "[%F %T] ";
      PROMPT_COMMAND = "history -a; $PROMPT_COMMAND";
      _ZO_DOCTOR = 0;
    };

    initExtra = let
      check-git = "git rev-parse --is-inside-work-tree &>/dev/null";
    in
      lib.mkMerge ([
          (lib.mkOrder 100 ''
            bind -x '"\C-o":${check-git} && { ruff format; ruff check --fix || ruff check --output-format grouped; }'
            bind -x '"\C-p":${check-git} && pre-commit'

            stty -ixon

            # colored manpages - https://gist.github.com/bahamas10/542875bb47990933638d2b7dfaa501bf
            export LESS_TERMCAP_mb=$'\e[1;36m'  # blinking
            export LESS_TERMCAP_md=$'\e[1;36m'  # bold text
            export LESS_TERMCAP_me=$'\e[0m'  # end all "_b." modes
            export LESS_TERMCAP_mh=$'\e[2m'  # dim
            export LESS_TERMCAP_mr=$'\e[7m'  # reverse-video
            # standout mode
            export LESS_TERMCAP_se=$'\e[0m'
            export LESS_TERMCAP_so=$'\e[1;30;43m'
            # "underline" mode
            export LESS_TERMCAP_ue=$'\e[0m'
            export LESS_TERMCAP_us=$'\e[4;1;32m'
            # Sub & Superscript
            export LESS_TERMCAP_ZN=$'\e[74m'
            export LESS_TERMCAP_ZO=$'\e[73m'
            export LESS_TERMCAP_ZV=$'\e[75m'
            export LESS_TERMCAP_ZW=$'\e[75m'
            # Fix groff settings to show colors
            export GROFF_NO_SGR=1;
          '')
        ]
        ++ lib.optionals (!setup.isNixOS) [
          (lib.mkAfter ''
            # Deduplicate PATH while preserving order
            if [ -n "$PATH" ]; then
              PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: '!a[$0]{a[$0]=1;print}' | sed 's/:$//')
              export PATH
            fi
          '')
        ]);
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
    bindings = {
      "\\C-s" = "nop"; # unbind ^s
    };
  };
  programs.nushell = {
    enable = false;
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
    defaultOptions = ["--bind ctrl-up:preview-half-page-up,ctrl-down:preview-half-page-down"];
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
  xdg.configFile."starship.toml".source = config.lib.meta.mkMutableSymlink dotfiles/starship.toml;

  programs.eza = {
    enable = true;
    icons = "auto";
    extraOptions = ["--group-directories-first"];
  };
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--max-columns-preview"
      "--max-columns=200"
      # "--follow"
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
  xdg.configFile."lesskey".source = config.lib.meta.mkMutableSymlink dotfiles/lesskey;

  xdg.configFile."bat".source = config.lib.meta.mkMutableSymlink dotfiles/bat;

  xdg.dataFile."ipython/profile_default/ipython_config.py".text = ''
    c = get_config()
    c.TerminalInteractiveShell.confirm_exit = False
  '';

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        insert_final_newline = true;
        trim_trailing_whitespace = true;
      };
      "*.py" = {
        indent_size = 4;
        indent_style = "space";
      };
    };
  };
}
