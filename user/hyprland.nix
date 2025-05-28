{pkgs, ...}: {
  # wayland.windowManager.hyprland.enable = true;
  home.packages = with pkgs; [
    hyprpaper
    hypridle
    waybar
    wofi

    grim
    slurp
  ];

  xdg.configFile."hypr/hypridle.conf".source = dotfiles/hypr/hypridle.conf;
}
