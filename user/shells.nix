{
  config,
  lib,
  pkgs,
  setup,
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
          # ble.sh must be sourced before everything that hooks the prompt and attached last
          (lib.mkOrder 50 ''
            source ${pkgs.blesh}/share/blesh/ble.sh --noattach
            bleopt exec_errexit_mark=
            bleopt exec_elapsed_mark=
            bleopt exec_exit_mark=
          '')
          (lib.mkOrder 300 ''
            ble-import integration/fzf-key-bindings
          '')
          # after fzf, so atuin owns ctrl-r
          (lib.mkOrder 2050 ''
            eval "$(atuin init bash --disable-up-arrow --disable-ai)"
          '')
          (lib.mkOrder 2100 ''
            [[ ''${BLE_VERSION-} ]] && ble-attach
          '')
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
            # Deduplicate while preserving order
            if [ -n "$PATH" ]; then
              PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: '!a[$0]{a[$0]=1;print}' | sed 's/:$//')
              export PATH
            fi
            if [ -n "$XDG_DATA_DIRS" ]; then
              XDG_DATA_DIRS=$(echo -n "$XDG_DATA_DIRS" | awk -v RS=: -v ORS=: '!a[$0]{a[$0]=1;print}' | sed 's/:$//')
              export XDG_DATA_DIRS
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
      "\\C-s" = "nop"; # unbind ^s, used by ghostty instead
    };
  };

  # init is done by hand in programs.bash.initExtra (ordering with ble.sh)
  programs.atuin = {
    enable = true;
    enableBashIntegration = false;
    settings = {
      auto_sync = false;
      update_check = false;
      ai.enabled = false;
      search.filters = [
        "workspace"
        "global"
        "directory"
      ];
      show_numeric_shortcuts = false;
      prefers_reduced_motion = true;
      db_path = "${config.xdg.dataHome}/atuin/history.db";
      key_path = "${config.xdg.dataHome}/atuin/key";
      session_path = "${config.xdg.dataHome}/atuin/session";
      record_store_path = "${config.xdg.dataHome}/atuin/records.db";
      meta.db_path = "${config.xdg.dataHome}/atuin/meta.db";
      logs.dir = "${config.xdg.stateHome}/atuin/logs";
      daemon.pidfile_path = "${config.xdg.stateHome}/atuin/daemon.pid";
    };
  };
}
