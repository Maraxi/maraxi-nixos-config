{pkgs, ...}: {
  home.packages = with pkgs; [
    # kanshi # hot switching output profiles
    wl-clipboard # wayland clipboard
    # wdisplays # arandr replacement
  ];
  services.dunst.enable = true;
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = ''${pkgs.sway}/bin/swaymsg "output * power off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * power on"'';
      }
    ];
  };
  programs.swaylock = {
    enable = true;
  };
}
