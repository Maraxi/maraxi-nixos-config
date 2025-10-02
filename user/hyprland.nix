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
    swappy
  ];

  services.hypridle.enable = true;

  xdg.configFile."hypr".source = config.lib.meta.mkMutableSymlink dotfiles/hypr;
  xdg.configFile."waybar".source = config.lib.meta.mkMutableSymlink dotfiles/waybar;
  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures
    save_filename_format=swappy-%Y%m%d-%H%M%S%z.png
    paint_mode=rectangle
    early_exit=true
  '';

  systemd.user.services.hyprland-ipc = {
    Unit = {
      Description = "React to Hyprland events via IPC";
      # ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Install = {
      # WantedBy = ["graphical.target"];
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
              hyprctl --batch "dispatch submap no-binds ; keyword cursor:no_warps false" >> /dev/null
              ;;
            activewindow\>\>*)
              if [[ no-binds = $(hyprctl submap) ]] ; then
                echo exiting no-binds
                hyprctl --batch "dispatch submap reset ; keyword cursor:no_warps true" >> /dev/null
              fi
              ;;
            # fullscreen\>\>1)
              # if hyprctl activewindow | grep -q firefox ; then
                # hyprctl dispatch fullscreenstate 0 -1 >> /dev/null
              # fi
              # ;;
          esac
          # SECONDS=0
        }

        ${pkgs.socat}/bin/socat -U - \
          UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock \
          | while read -r line; do handle "$line"; done
      ''}";
    };
  };
}
