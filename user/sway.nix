{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # mako # wayland notification daemon
    # sway-contrib.grimshot
    # grim
    # slurp # wayland screenshots
    # wf-recorder
    # kanshi # hot switching output profiles
    wl-clipboard # wayland clipboard
    # shotman # wayland screenshots
    # flameshot
  ];
  services.mako.enable = true;
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 120;
        command = ''${pkgs.sway}/bin/swaymsg "output * power off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * power on"'';
      }
    ];
  };

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    config = rec {
      modifier = "Mod1";
      terminal = "${pkgs.alacritty}/bin/alacritty";
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
          xkb_variant = "nodeadkeys";
          xkb_options = "caps:escape_shifted_capslock,compose:sclk";
        };
      };
      workspaceLayout = "tabbed";
      defaultWorkspace = "workspace number 1";
      focus.followMouse = false;
      focus.mouseWarping = false;
      colors = let
        cl_high = "#080899";
        cl_indi = "#d9d8d8";
        cl_back = "#231f20";
        cl_fore = "#d9d8d8";
        cl_urge = "#ff69b4";
      in {
        focused = {
          background = "${cl_high}";
          border = "${cl_high}";
          text = "${cl_fore}";
          indicator = "${cl_indi}";
          childBorder = "${cl_back}";
        };
        focusedInactive = {
          background = "${cl_back}";
          border = "${cl_back}";
          text = "${cl_fore}";
          indicator = "${cl_back}";
          childBorder = "${cl_back}";
        };
        unfocused = {
          background = "${cl_back}";
          border = "${cl_back}";
          text = "${cl_fore}";
          indicator = "${cl_back}";
          childBorder = "${cl_back}";
        };
        urgent = {
          background = "${cl_urge}";
          border = "${cl_urge}";
          text = "${cl_fore}";
          indicator = "${cl_urge}";
          childBorder = "${cl_urge}";
        };
      };
      output = {
        # swaymsg -t get_outputs
        eDP-1 = {
          pos = "0 150";
          # bg = "$HOME/.background.png fill";
        };
        HDMI-A-2 = {
          pos = "1600 0";
          # mode = "1920x1080@60Hz";
        };
      };
      keybindings = let
        cfg = config.wayland.windowManager.sway.config;
        meh = "${modifier}+Ctrl+Shift";
      in {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${cfg.menu}";
        "${modifier}+Shift+q" = "kill";

        "${modifier}+${cfg.left}" = "focus left";
        "${modifier}+${cfg.down}" = "focus down";
        "${modifier}+${cfg.up}" = "focus up";
        "${modifier}+${cfg.right}" = "focus right";

        "${modifier}+Shift+${cfg.left}" = "move workspace to output left";
        "${modifier}+Shift+${cfg.down}" = "move down";
        "${modifier}+Shift+${cfg.up}" = "move up";
        "${modifier}+Shift+${cfg.right}" = "move workspace to output right";

        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+a" = "focus parent";

        "${modifier}+e" = "layout toggle tabbed splith";

        "${meh}+f" = "fullscreen toggle";
        "${meh}+l" = "floating toggle";
        "${meh}+o" = "focus mode_toggle";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        "${modifier}+Shift+comma" = "move scratchpad";
        "${modifier}+comma" = "scratchpad show";

        "${modifier}+Tab" = "workspace back_and_forth";

        "${modifier}+Shift+c" = "reload";

        "${modifier}+Shift+d" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";

        "${meh}+r" = "mode resize";
        "${meh}+a" = "mode $mode_applications";
        "${modifier}+s" = "mode $mode_sound";
        "${modifier}+o" = "mode $mode_power";

        "${meh}+p" = "exec ${pkgs.wf-recorder}/bin/wf-recorder -g \"$(${pkgs.slurp}/bin/slurp)\" -c gif --file ~/Bilder/\"$(date +'recording_%Y-%m-%dT%H-%M-%S%z.gif')\" && mode $mode_record";
        "${modifier}+p" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" ~/Bilder/\"$(date +'grim_%Y-%m-%dT%H-%M-%S%z.png')\"";
      };
      assigns = {
        # swaymsg -t get_tree
        "8" = [{app_id = "^thunderbird$";}];
        "9" = [{title = "^KeeData.kdbx";}];
      };
    };
    extraConfig = ''
      set $mode_applications "[t]hunderbird [l]ibrewolf [k]eepass key[m]app"
      mode $mode_applications {
        bindsym t exec ${pkgs.thunderbird}/bin/thunderbird
        bindsym f exec ${pkgs.firefox}/bin/firefox
        bindsym k exec ${pkgs.keepassxc}/bin/keepassxc
        bindsym m exec ${pkgs.keymapp}/bin/keymapp
        bindsym Return mode default
        bindsym Escape mode default
      }
      set $mode_record "Recording Ctrl+Esc to quit"
      mode $mode_record {
        bindsym Ctrl+Escape exec pkill -SIGINT wf-recorder; mode default
      }
      set $mode_sound "[m]ute [u]p [d]own"
      mode $mode_sound {
        bindsym m exec ${pkgs.pamixer}/bin/pamixer -t
        bindsym u exec ${pkgs.pamixer}/bin/pamixer -i 3
        bindsym d exec ${pkgs.pamixer}/bin/pamixer -d 3
        bindsym Return mode default
        bindsym Escape mode default
      }
      set $mode_power "Power: [h]ibernate [s]uspend [l]ogout [p]oweroff"
      mode $mode_power {
        bindsym h exec --no-startup-id systemctl hibernate, mode default
        bindsym s exec --no-startup-id systemctl suspend, mode default
        bindsym l exit
        bindsym p exec --no-startup-id poweroff
        bindsym Return mode default
        bindsym Escape mode default
      }

      exec_always wallpaper
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
    wrapperFeatures.gtk = true;
  };
}
