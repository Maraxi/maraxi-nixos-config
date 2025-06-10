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

  services.hypridle.enable = true;

  xdg.configFile."hypr".source = config.lib.meta.mkMutableSymlink dotfiles/hypr;
  xdg.configFile."waybar".source = config.lib.meta.mkMutableSymlink dotfiles/waybar;
}
