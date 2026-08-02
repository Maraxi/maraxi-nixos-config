{
  pkgs,
  lib,
  ...
}: {
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID"; # set the runtime directory to unlock keyring
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = lib.replaceString "\n" " " ''
        ${pkgs.tuigreet}/bin/tuigreet
        --time
        --asterisks
        --user-menu
        --remember
        --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red
        --cmd Hyprland'';
    };
    useTextGreeter = true;
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
