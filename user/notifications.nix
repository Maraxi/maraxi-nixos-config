{ config, pkgs, ... }: {
  services.dunst = {
    enable = true;
    configFile = config.lib.meta.mkMutableSymlink dotfiles/dunstrc;
  };
  home.packages = [
    pkgs.papirus-icon-theme
  ];
  xdg.configFile."dunst/dunstrc".enable = false;
  xdg.configFile."dunst/readme".text =
    "Managed by home-manager. See the config used by service instead:\nsystemctl --user status dunst.service";
}
