{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellScriptBin "remmina-connect.sh" ''
      REMMINA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/remmina"

      if [[ ! -d $REMMINA_DIR ]]; then
        notify-send "Remmina" "Folder $REMMINA_DIR does not exist"
        exit 1
      fi

      shopt -s nullglob
      files=("$REMMINA_DIR"/*.remmina)

      if ((''${#files[@]} == 0)); then
        notify-send "Remmina" "No connection profiles in $REMMINA_DIR"
        exit 1
      fi

      if ((''${#files[@]} == 1)); then
        exec remmina -c "''${files[0]}"
      fi

      declare -A entries
      for file in "''${files[@]}"; do
        name=$(sed -n 's/^name=//p' "$file" | head -n1)
        [[ -z $name ]] && name=$(basename "''${file%.remmina}")
        entries["$name - $file"]=$file
      done

      selected=$(printf '%s\n' "''${!entries[@]}" | sort | wofi --dmenu --prompt "Remmina")

      [[ -z $selected ]] && exit 0

      file=''${entries[$selected]}
      if [[ -z $file ]]; then
        notify-send "Remmina" "Could not find the selected profile"
        exit 1
      fi

      exec remmina -c "$file"
    '')
  ];

  xdg.desktopEntries."remmina-connect" = {
    type = "Application";
    name = "Remmina Connect";
    comment = "Pick a Remmina connection profile and start it";
    terminal = false;
    exec = "remmina-connect.sh";
    icon = "org.remmina.Remmina";
    categories = [ "Network" ];
  };
}
