{pkgs, ...}: {
  home.packages = with pkgs; [
    mako # wayland notification daemon
    sway-contrib.grimshot
    # grim
    # slurp # wayland screenshots
    # wf-recorder
    # kanshi # hot switching output profiles
    wl-clipboard # wayland clipboard
    # shotman # wayland screenshots
    # flameshot
  ];
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    config = rec {
      terminal = "alacritty";
      input = {
        # swaymsg -t get_inputs
        "1008:36:CHICONY_HP_Basic_USB_Keyboard" = {
          xkb_layout = "de";
          xkb_variant = "nodeadkeys";
          xkb_options = "caps:escape_shifted_capslock,compose:sclk";
          xkb_numlock = "enabled";
        };
        "type:keyboard" = {
          xkb_layout = "de";
        };
      };
      defaultWorkspace = "workspace number 1";
      focus.followMouse = false;
      focus.mouseWarping = false;
      output = {
        # swaymsg -t get_outputs
        eDP-1 = {
          pos = "0 150";
          # bg = "$HOME/arch/Furry/5c15126e906b533c9caf28ee14155aa4.png fill";
        };
        HDMI-A-2 = {
          pos = "1600 0";
          # mode = "1920x1080@60Hz";
        };
        "*" = {bg = "/home/stefan/.background-image fill";};
      };
      workspaceLayout = "tabbed";
    };
    extraConfig = ''
      bindsym Mod1+Ctrl+Shift+t exec thunderbird
      set $mode_power "Power: [h]ibernate [s]uspend"
      bindsym Mod1+o mode $mode_power
      mode $mode_power {
        bindsym h exec systemctl hibernate, mode default
        bindsym s exec systemctl suspend, mode default
        bindsym Return mode default
        bindsym Escape mode default
      }
    '';
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      # export QT_QPA_PLATFORM=wayland
      # export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      # export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    # wrapperFeatures.gtk = true;
  };
}
