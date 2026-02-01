#! /usr/bin/env nix
#! nix shell nixpkgs#inotify-tools --command bash

# Strict mode
set -euo pipefail
set -x
# IFS=$'\n\t'


CONFIG_FILES="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/style.css"

# trap "pkill waybar" EXIT

while true; do
    pkill -SIGUSR2 waybar
    sleep 0.5
    inotifywait -e create,modify,move_self $CONFIG_FILES
    sleep 0.1
done
