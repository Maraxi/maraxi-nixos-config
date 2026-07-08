{
  setup,
  config,
  lib,
  pkgs,
  ...
}: {
  home.sessionVariables = rec {
    EDITOR = "nvim";
    VISUAL = "nvim";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    RUFF_CACHE_DIR = XDG_CACHE_HOME + "/ruff_cache";
    UV_EXLUDE_NEWER = "3 days";

    PYTHON_HISTORY = XDG_STATE_HOME + "/python-history";
    IPYTHONDIR = XDG_DATA_HOME + "/ipython";

    CARGO_HOME = XDG_DATA_HOME + "/cargo";
    RUSTUP_HOME = XDG_DATA_HOME + "/rustup";

    PARALLEL_HOME = XDG_CONFIG_HOME + "/parallel";

    MPLAYER_HOME = XDG_CONFIG_HOME + "/mplayer";

    _JAVA_OPTIONS =
      "-Djava.util.prefs.userRoot="
      + XDG_CONFIG_HOME
      + "/java "
      + "-Djavafx.cachedir="
      + XDG_CACHE_HOME
      + "/openjfx";

    DOCKER_CONFIG = XDG_CONFIG_HOME + "/docker";
    MACHINE_STORAGE_PATH = XDG_DATA_HOME + " /docker-machine";

    KUBECONFIG = XDG_CONFIG_HOME + "/kube";
    KUBECACHEDIR = XDG_CACHE_HOME + "/kube";

    NPM_CONFIG_USERCONFIG = XDG_CONFIG_HOME + "/npm/npmrc";

    CUDA_CACHE_PATH = XDG_CACHE_HOME + "/nv";
  };
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];
  home.file."bin".source = config.lib.meta.mkMutableSymlink dotfiles/bin;

  xdg.desktopEntries."nvim-new-term" = {
    type = "Application";
    name = "Neovim in new term";
    terminal = false;
    exec = "ghostty +new-window -e nvim-link-handler %u";
    mimeType = ["x-scheme-handler/nvim"];
  };
  home.packages = [
    (pkgs.writeShellScriptBin "nvim-link-handler" ''
      set -euo pipefail

      if [[ -z ''${1:-} ]]; then
          # no argument
          nvim
          exit 0
      fi

      if [[ "''$1" != *:* ]]; then
          # no protocol, just file name
          nvim "$1"
          exit 0
      fi

      protocol="''${1%%://*}"
      case "$protocol" in
          nvim)
              file=$(echo "$1" | sed -E 's|.*file=([^&]*).*|\1|')
              line=$(echo "$1" | sed -E 's|.*line=([^&]*).*|\1|')
              nvim "+$line" "$file"
              ;;
          file)
              nvim "''${1#file://}"
              ;;
          *)
              echo -ne "unknown protocol:\n$protocol\npress enter to exit"
              read -r
              exit 1
              ;;
      esac
      exit 0
    '')
  ];

  xdg.mimeApps = let
    editor = "nvim-new-term.desktop";
    browser =
      if setup.isNixOS
      then "firefox.desktop"
      else "microsoft-edge.desktop";
    mailer =
      if setup.isNixOS
      then "thunderbird.desktop"
      else browser;
    image_viewer = ["org.gnome.gThumb.desktop" "feh.desktop"];
    video_viewer = ["org.gnome.gThumb.desktop" "vlc.desktop"];
    text-mime-types = builtins.readFile ./text-mime-types.txt |> lib.splitString "\n" |> builtins.filter (x: x != "");
    association =
      {
        "application/json" = editor;
        "application/pdf" = ["org.gnome.Evince.desktop" browser];
        "application/x-desktop" = editor;
        "application/x-gnome-saved-search" = "nemo.desktop";
        "default-url-scheme-handler" = browser;
        "default-web-browser" = browser;
        "image/avif" = image_viewer;
        "image/gif" = video_viewer;
        "image/jpeg" = image_viewer;
        "image/png" = image_viewer;
        "image/webp" = image_viewer;
        "inode/directory" = "nemo.desktop";
        "message/rfc822" = "thunderbird.desktop";
        "text/html" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/mailto" = mailer;
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
        "x-scheme-handler/unknown" = browser;
      }
      // builtins.listToAttrs (map (type: {
          name = "text/${type}";
          value = editor;
        })
        text-mime-types);
  in {
    enable = true;
    defaultApplications = association;
    associations.added = association;
  };
}
