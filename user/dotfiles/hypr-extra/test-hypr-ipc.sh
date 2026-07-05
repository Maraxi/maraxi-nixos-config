#! /usr/bin/env nix
#! nix shell nixpkgs#socat --command bash
# shellcheck shell=bash

# Strict mode
set -euo pipefail
IFS=$'\n\t'

# set -x

handle() {
  # ((SECONDS > 0)) && echo -e '\nreceived batch'
  echo "$1"

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
      # fullscreen\>\>1)
      #   if hyprctl activewindow | grep -q firefox ; then
      #     hyprctl dispatch 'hl.dsp.window.fullscreen_state({internal=0, client=-1})' >> /dev/null
      #   fi
      #   ;;
  esac
  # SECONDS=0
}

socat -U - \
  UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock |
  while read -r line; do handle "$line"; done
