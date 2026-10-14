{
  lib,
  setup,
  mutableLink,
  ...
}:
{
  programs.bash = {
    enable = true;

    historySize = -1;
    historyFileSize = -1;
    historyFile = "$XDG_STATE_HOME/bash_history_eternal";
    historyControl = [
      "ignorespace"
      "ignoredups"
    ];

    sessionVariables = {
      HISTTIMEFORMAT = "[%F %T] ";
      PROMPT_COMMAND = "history -a; $PROMPT_COMMAND";
      _ZO_DOCTOR = 0;
    };

    initExtra =
      let
        check-git = "git rev-parse --is-inside-work-tree &>/dev/null";
      in
      lib.mkMerge (
        [
          (lib.mkOrder 100 ''
            eval "$(devenv hook bash)"

            bind -x '"\C-o":${check-git} && { ruff format; ruff check --fix || ruff check --output-format grouped; }'
            bind -x '"\C-p":${check-git} && prek'

            stty -ixon

            # colored manpages - https://gist.github.com/bahamas10/542875bb47990933638d2b7dfaa501bf
            # see also in lesskey
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
        ]
      );
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
}
