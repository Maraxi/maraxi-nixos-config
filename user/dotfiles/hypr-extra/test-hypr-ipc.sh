#! /usr/bin/env nix
#! nix shell nixpkgs#socat --command bash
# shellcheck shell=bash

# Strict mode
set -euo pipefail
IFS=$'\n\t'

# set -x

handle() {
  ((SECONDS > 0)) && echo -e '\nreceived batch'
  echo "$1"

  case $1 in
    activewindow\>\>dota2*)
	echo "entering no-binds"
	hyprctl dispatch submap no-binds >> /dev/null
	;;
    activewindow\>\>*)
	if [[ no-binds = $(hyprctl submap) ]]; then
	    echo exiting no-binds
	    hyprctl dispatch submap reset >> /dev/null
	fi
	;;
    fullscreen\>\>1)
	if hyprctl activewindow | grep -z firefox | grep -qz "fullscreen: 2" ; then
	    echo foo;
	    hyprctl dispatch fullscreenstate 0 -1
	fi
	;;
  esac
  SECONDS=0
}

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "$line"; done
