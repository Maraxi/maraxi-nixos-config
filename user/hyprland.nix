{
  config,
  pkgs,
  pkgs-stable,
  inputs,
  ...
}:
{
  # wayland.windowManager.hyprland.enable = true;
  home.packages =
    with pkgs;
    [
      hyprpaper
      hypridle

      grim
      slurp
      satty
      # wf-recorder
    ]
    ++ [ pkgs-stable.wf-recorder ]
    ++ [ inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  # dmenu like launcher
  programs.wofi = {
    enable = true;
    settings = {
      key_expand = "Left,Right";
    };
  };

  xdg.configFile."wofi/wallpaper".source = config.lib.meta.mkMutableSymlink dotfiles/wofi-wallpaper;
  xdg.configFile."hypr".source = config.lib.meta.mkMutableSymlink dotfiles/hypr;
  xdg.configFile."waybar".source = config.lib.meta.mkMutableSymlink dotfiles/waybar;
  xdg.configFile."satty/config.toml".source = config.lib.meta.mkMutableSymlink dotfiles/satty.toml;

  services.hypridle.enable = true;

  systemd.user.services.hyprland-ipc = {
    Unit = {
      Description = "React to Hyprland events via IPC";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = [
        "WAYLAND_DISPLAY"
        "HYPRLAND_INSTANCE_SIGNATURE"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Restart = "on-failure";
      RestartSec = 1;
      ExecStart = "${pkgs.writeShellScript "hyprland-ipc" ''
        # shellcheck shell=bash

        # Strict mode
        set -euo pipefail
        IFS=$'\n\t'

        # set -x

        handle() {
          # ((SECONDS > 0)) && echo -e '\nreceived batch'
          # echo "$1"

          case $1 in
            activewindow\>\>dota2*)
              echo "entering no-binds"
              hyprctl eval 'function f()
                                hl.dispatch(hl.dsp.submap("no-binds"))
                                hl.config({cursor = {no_warps = false}})
                            end; f()' >>/dev/null
              ;;
            activewindow\>\>*)
              if [[ "no-binds" == $(hyprctl submap) ]]; then
                echo exiting no-binds
                hyprctl eval 'function f()
                                  hl.dispatch(hl.dsp.submap("reset"))
                                  hl.config({cursor = {no_warps = true}})
                              end; f()' >>/dev/null
              fi
              ;;
          esac
          # SECONDS=0
        }

        ${pkgs.socat}/bin/socat -U - \
          UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock |
          while read -r line; do handle "$line"; done
      ''}";
    };
  };
}
