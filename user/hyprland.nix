{
  config,
  pkgs,
  ...
}: {
  # wayland.windowManager.hyprland.enable = true;
  home.packages = with pkgs; [
    hyprpaper
    hypridle
    waybar
    wofi

    grim
    slurp
  ];

  xdg.configFile."hypr".source = config.lib.meta.mkMutableSymlink dotfiles/hypr;
}
