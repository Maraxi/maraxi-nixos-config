{
  config,
  pkgs,
  ...
}: {
  # wayland.windowManager.hyprland.enable = true;
  home.packages = with pkgs; [
    hyprpaper
    hypridle
    waybar
    wofi

    grim
    slurp
  ];

  services.hypridle.enable = true;

  xdg.configFile."hypr".source = config.lib.meta.mkMutableSymlink dotfiles/hypr;
  xdg.configFile."waybar".source = config.lib.meta.mkMutableSymlink dotfiles/waybar;

  systemd.user.services.hyprland-ipc = {
    Unit = {
      Description = "React to Hyprland events via IPC";
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "hyprland-ipc" ''
        #! /usr/bin/env bash

        # Strict mode
        set -euo pipefail
        IFS=$'\n\t'

        # set -x

        handle() {
          # ((SECONDS > 0)) && echo -e '\nreceived batch'
          # echo $1

          case $1 in
            activewindow\>\>dota2*)
              echo "entering no-binds"
              hyprctl dispatch submap no-binds >> /dev/null
              ;;
            activewindow\>\>*)
              [[ no-binds = $(hyprctl submap) ]] && echo exiting no-binds && hyprctl dispatch submap reset >> /dev/null || true
              ;;
          esac
          # SECONDS=0
        }

        ${pkgs.socat}/bin/socat -U - \
          UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock \
          | while read -r line; do handle "$line"; done
      ''}";
    };
  };
}
