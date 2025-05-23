{pkgs, ...}: {
  # wayland.windowManager.hyprland.enable = true;
  home.packages = with pkgs; [
    hyprpaper
    hypridle
    waybar
    wofi
  ];
}
