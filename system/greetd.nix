{
  pkgs,
  lib,
  ...
}:
{
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = lib.replaceString "\n" " " ''
        ${pkgs.tuigreet}/bin/tuigreet
        --cmd "uwsm start hyprland.desktop"
        --remember
        --asterisks
        --user-menu
        --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red
        --time'';
    };
    useTextGreeter = true;
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
