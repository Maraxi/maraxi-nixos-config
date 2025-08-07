{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.tuigreet}/bin/tuigreet \
         --time \
         --asterisks \
         --user-menu \
         --remember \
         --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red \
         --cmd Hyprland
      '';
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
