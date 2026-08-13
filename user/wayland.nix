{ pkgs, ... }: {
  home.packages = with pkgs; [
    # kanshi # hot switching output profiles
    wl-clipboard # wayland clipboard
    wdisplays # arandr replacement
  ];
  services.dunst.enable = true;

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      font-size = 24;
      indicator-idle-visible = true;
      indicator-radius = 100;
      indicator-thickness = 15;
      line-color = "000000";
      show-failed-attempts = true;
      ignore-empty-password = true;
    };
  };
}
