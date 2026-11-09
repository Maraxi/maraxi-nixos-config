{ pkgs, setup, ... }: {
  xdg = {
    mimeApps =
      let
        editor = "nvim-new-term.desktop";
        browser = if setup.isNixOS then "firefox.desktop" else "microsoft-edge.desktop";
        mailer = if setup.isNixOS then "thunderbird.desktop" else browser;
        image_viewer = [
          "swayimg.desktop"
          "org.gnome.gThumb.desktop"
        ];
        video_viewer = [
          "mpv.desktop"
          "vlc.desktop"
          "org.gnome.gThumb.desktop"
        ];
        association = {
          "application/json" = editor;
          "application/pdf" = [
            "org.gnome.Evince.desktop"
            browser
          ];
          "application/x-desktop" = editor;
          "default-url-scheme-handler" = browser;
          "default-web-browser" = browser;
          "image/*" = image_viewer;
          "inode/directory" = "pcmanfm-qt.desktop";
          "message/rfc822" = "thunderbird.desktop";
          "text/*" = editor;
          "text/html" = browser;
          "video/*" = video_viewer;
          "x-scheme-handler/about" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/mailto" = mailer;
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
          "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
          "x-scheme-handler/unknown" = browser;
        };
      in
      {
        enable = true;
        defaultApplications = association;
        associations.added = association;
      };

    desktopEntries."nvim-new-term" = {
      type = "Application";
      name = "Neovim in new term";
      terminal = false;
      exec = "ghostty +new-window -e nvim-link-handler %u";
      mimeType = [ "x-scheme-handler/nvim" ];
    };
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
              if [[ -e $1 ]]; then
                  nvim "$1"
              else
                  echo -ne "unknown protocol:\n$protocol\npress enter to exit"
                  read -r
                  exit 1
              fi
              ;;
      esac
      exit 0
    '')
  ];

}
