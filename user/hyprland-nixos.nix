# Hyprland on the NixOS desktop. Hyprland itself comes from system/hyprland.nix, the shared setup from hyprland.nix.
{ mutableLink, pkgs, ... }:
{
  home.packages = [ pkgs.hyprpaper ];

  xdg.configFile = {
    "hypr/hyprland.lua" = mutableLink dotfiles/hypr/hyprland-desktop.lua;
    "hypr/hypridle.conf" = mutableLink dotfiles/hypr/hypridle-desktop.conf;
    "hypr/hyprpaper.conf" = mutableLink dotfiles/hypr/hyprpaper-desktop.conf;

    "uwsm/env-hyprland".text = ''
      # The nvidia card is the only gpu here (no iGPU). nvidia-vaapi-driver comes from
      # hardware.nvidia.videoAcceleration (default true).
      export LIBVA_DRIVER_NAME=nvidia
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
    '';
  };

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
