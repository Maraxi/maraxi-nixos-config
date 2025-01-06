{
  pkgs,
  config,
  setup,
  ...
}: let
  modifier = "Mod1";
  terminal = "${pkgs.alacritty}/bin/alacritty";

  focus = {
    followMouse = false;
    mouseWarping = false;
  };

  keybindings = {
    "${modifier}+Return" = "exec ${terminal}";
  };

  colors = let
    cl_high = "#080899";
    cl_indi = "#d9d8d8";
    cl_back = "#231f20";
    cl_fore = "#d9d8d8";
    cl_urge = "#9966ff";
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
in
  if setup.isNixOS
  then {
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
      config = {
        modifier = modifier;
        terminal = terminal;

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
        focus = focus;
        colors = colors;
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
        in
          keybindings
          // {
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
        set $mode_applications "[t]hunderbird [f]irefox [k]eepass key[m]app"
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
  else {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = modifier;
        terminal = terminal;

        bars = [];
        colors = colors;
        floating.modifier = "${modifier}";
        focus = focus;
        fonts = {
          names = ["DejaVu Sans Mono" "FontAwesome5Free"];
          style = "Bold Semi-Condensed";
          size = 11.0;
        };
        keybindings = keybindings;
        modes = {};
      };
      extraConfig = ''
        # Should you change your keyboard layout some time, delete
        # this file and re-run i3-config-wizard(1).

        # i3 config file (v4)
        # Please see https://i3wm.org/docs/userguide.html for a complete reference!

        set $mod Mod1
        set $meh Ctrl+Shift+Mod1

        # Start XDG autostart .desktop files using dex. See also
        # https://wiki.archlinux.org/index.php/XDG_Autostart
        exec --no-startup-id dex --autostart --environment i3

        # The combination of xss-lock, nm-applet and pactl is a popular choice, so
        # they are included here as an example. Modify as you see fit.

        # xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
        # screen before suspend. Use loginctl lock-session to lock your screen.
        # exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork

        # NetworkManager is the most popular way to manage wireless networks on Linux,
        # and nm-applet is a desktop environment-independent system tray GUI for it.
        exec --no-startup-id nm-applet

        # Use pactl to adjust volume in PulseAudio.
        # set $refresh_i3status killall -SIGUSR1 i3status
        set $hdmi_sink "alsa_output.pci-0000_01_00.1.hdmi-stereo"
        set $sound_mode "SOUND volume [u]p [d]own [m]ute - hdmi [r]aise [l]ower [0]mute - i:toggle mic mute"
        mode $sound_mode {
                bindsym u exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% # && $refresh_i3status
                bindsym d exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% # && $refresh_i3status
                bindsym m exec --no-startup-id pactl set-sink-mute   @DEFAULT_SINK@ toggle # && $refresh_i3status
                bindsym r exec --no-startup-id pactl set-sink-volume $hdmi_sink +5%
                bindsym l exec --no-startup-id pactl set-sink-volume $hdmi_sink -5%
                bindsym 0 exec --no-startup-id pactl set-sink-mute   $hdmi_sink toggle # && $refresh_i3status
                bindsym i exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle # && $refresh_i3status
                bindsym Escape mode "default"
                bindsym Enter mode "default"
        }
        bindsym $meh+s mode $sound_mode

        # screensaver
        exec_always --no-startup-id xset +dpms
        exec_always --no-startup-id xset s 540

        # Set monitors for home setup
        # reference $ man xkeyboard-config
        set $keyboard_layout "setxkbmap de -variant nodeadkeys -option 'caps:escape,compose:rctrl'"
        set $keyboard_layout_us "setxkbmap us -option 'caps:escape,compose:rctrl'"
        exec_always --no-startup-id $keyboard_layout
        set $feh feh --bg-fill /home/iv546/Pictures/wallpaper/wallpaperflare.com_wallpaper.jpg
        exec --no-startup-id "/home/iv546/.config/arandr/arandr-home.sh; $feh"

        set $window_mode "WINDOW x:xrandr a:arandr f:feh k:keyboard u:us-layout 1-3:presets"
        mode $window_mode {
                bindsym x exec --no-startup-id xrandr --auto
                bindsym a exec --no-startup-id arandr
                bindsym f exec --no-startup-id $feh
                bindsym k mode "default", exec --no-startup-id $keyboard_layout
                bindsym u mode "default", exec --no-startup-id $keyboard_layout_us
                bindsym 1 exec --no-startup-id "/home/iv546/.config/arandr/arandr-home.sh; $feh"
                bindsym 2 exec --no-startup-id "/home/iv546/.config/arandr/arandr-office-2-monitors.sh; $feh"
                bindsym 3 exec --no-startup-id "/home/iv546/.config/arandr/arandr-office-2-monitors-right.sh; $feh"

                # back to normal: Enter or Escape or $mod+r
                bindsym Return mode "default"
                bindsym Escape mode "default"
        }
        bindsym $meh+w mode $window_mode

        # Use a tabbed as default layout
        workspace_layout tabbed

        # kill focused window
        bindsym $meh+q kill

        # start dmenu (a program launcher)
        bindsym $mod+d exec --no-startup-id dmenu_run
        # A more modern dmenu replacement is rofi:
        # bindcode $mod+40 exec "rofi -modi drun,run -show drun"
        # There also is i3-dmenu-desktop which only displays applications shipping a
        # .desktop file. It is a wrapper around dmenu, so you need that installed.
        bindsym $mod+Shift+d exec --no-startup-id i3-dmenu-desktop

        # change focus
        bindsym $mod+h focus left
        bindsym $mod+j focus down
        bindsym $mod+k focus up
        bindsym $mod+l focus right

        # move focused window
        bindsym $mod+Shift+h move left
        bindsym $mod+Shift+j move down
        bindsym $mod+Shift+k move up
        bindsym $mod+Shift+l move right

        # alternatively, you can use the cursor keys:
        bindsym $mod+Shift+Right move workspace to output right
        bindsym $mod+Shift+Left move workspace to output left

        # split in horizontal orientation
        bindsym $mod+Shift+b split h

        # split in vertical orientation
        bindsym $mod+Shift+v split v

        # enter fullscreen mode for the focused container
        bindsym $meh+f fullscreen toggle

        # change container layout (stacked, tabbed, toggle split)
        bindsym $meh+t layout toggle tabbed splith

        # toggle tiling / floating
        bindsym $meh+l floating toggle

        # change focus between tiling / floating windows
        bindsym $mod+space focus mode_toggle

        # focus the parent container
        # bindsym $mod+a focus parent

        # focus the child container
        #bindsym $mod+d focus child

        # focus urgent/recent
        bindsym $meh+u [urgent="latest"] focus
        bindsym $mod+Tab workspace back_and_forth

        # scratchpad
        bindsym $mod+Shift+comma move scratchpad
        bindsym $mod+comma scratchpad show

        # Define names for default workspaces for which we configure key bindings later on.
        # We use variables to avoid repeating the names in multiple places.
        set $ws1 "1"
        set $ws2 "2"
        set $ws3 "3"
        set $ws4 "4"
        set $ws5 "5"
        set $ws6 "6"
        set $ws7 "7"
        set $ws8 "8"
        set $ws9 "9"
        set $ws10 "10"

        # switch to workspace
        bindsym $mod+1 workspace number $ws1
        bindsym $mod+2 workspace number $ws2
        bindsym $mod+3 workspace number $ws3
        bindsym $mod+4 workspace number $ws4
        bindsym $mod+5 workspace number $ws5
        bindsym $mod+6 workspace number $ws6
        bindsym $mod+7 workspace number $ws7
        bindsym $mod+8 workspace number $ws8
        bindsym $mod+9 workspace number $ws9
        bindsym $mod+0 workspace number $ws10

        # move focused container to workspace
        bindsym $mod+Shift+1 move container to workspace number $ws1
        bindsym $mod+Shift+2 move container to workspace number $ws2
        bindsym $mod+Shift+3 move container to workspace number $ws3
        bindsym $mod+Shift+4 move container to workspace number $ws4
        bindsym $mod+Shift+5 move container to workspace number $ws5
        bindsym $mod+Shift+6 move container to workspace number $ws6
        bindsym $mod+Shift+7 move container to workspace number $ws7
        bindsym $mod+Shift+8 move container to workspace number $ws8
        bindsym $mod+Shift+9 move container to workspace number $ws9
        bindsym $mod+Shift+0 move container to workspace number $ws10


        # Identify windows with "xprop" or "xwininfo -tree -root"
        # Floating windows in Citrix
        # TODO
        for_window [class="^Adobe Acrobat$"] floating enable
        for_window [class="^Wfica$"] floating enable
        for_window [class="^Find$"] floating enable
        for_window [instance="^Notepad$"] floating enable
        for_window [class="^Microsoft Excel$"] floating enable
        # No floating for cyberark connections
        for_window [class="^xfreerdp$"] floating disable
        # No floating for pychrarm settings
        for_window [class="^jetbrains-pycharm$" title="^Settings$"] floating disable

        # Assign workspaces
        set $output_other DP-1-1.3 DP-1-1.8 DP-1-1.1.8 DP-1.3
        workspace $ws1 output $output_other
        workspace $ws2 output $output_other
        workspace $ws3 output $output_other
        workspace $ws8 output primary
        workspace $ws9 output primary
        workspace $ws10 output primary
        assign [class="^Chromium"] → 1
        assign [class="^jetbrains-pycharm$"] → 2
        assign [class="^org.remmina.Remmina$"] → 3
        assign [class="^Pavucontrol$"] → 8
        assign [class="^KeePassXC$" title="^KeePassXC$"] → 9
        assign [class="^KeePassXC$" title="^Passwords.*KeePassXC$"] → 9
        assign [class="^Keymapp$"] → 10
        # Citrix
        # assign [class="^File Explorer$"] → 4
        # assign [class="^Google Chrome$"] → 4

        for_window [class="^Update-manager$"] floating disable
        no_focus [class="^Update-manager$"]
        # no_focus [class="KeePassXC$" title="^KeePassXC$"]
        # focus_on_window_activation [class="KeePassXC$" title="^KeePassXC$"] none
        focus_on_window_activation smart

        # Startup
        exec keepassxc

        # Applications
        set $apps_mode "Apps C:chrome R:remmina V:pavucontrol P:pycharm S:pass K:keepass M:keymapp F:flameshot"
        mode $apps_mode {
                # bindsym c mode "default", exec --no-startup-id "/snap/bin/chromium --proxy-pac-url=http://webproxy.deutsche-boerse.de:8080"
                # bindsym Shift+c mode "default", exec --no-startup-id "/snap/bin/chromium"
                bindsym c mode "default", exec chromium
                bindsym r mode "default", exec remmina -i
                bindsym v mode "default", exec pavucontrol
                bindsym p mode "default", exec pycharm-professional
                bindsym s mode "default", exec pass
                bindsym k mode "default", exec keepassxc
                bindsym m mode "default", exec keymapp
                bindsym f mode "default", exec flameshot gui #TODO prntscn button
                # bindsym g mode "default", exec gif
                # back to normal: Enter or Escape
                bindsym Return mode "default"
                bindsym Escape mode "default"
        }
        bindsym $meh+a mode $apps_mode

        bindsym Print exec flameshot gui

        # reload the configuration file
        bindsym $meh+c reload
        # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
        bindsym $meh+r restart

        # clear all dunst notifications
        bindsym $meh+d exec "dunstctl close-all"

        set $lock i3lock -efc 000000 && sleep 1
        set $display_off xset dpms force off
        set $exit_mode "EXIT o:lock s:suspend h:hibernate e:logout u:switch-user p:poweroff x:screen-off"
        mode $exit_mode {
                bindsym o mode "default" , exec $lock && exec $display_off
                bindsym s mode "default" , exec $lock && exec systemctl suspend
                bindsym h mode "default" , exec $lock && exec systemctl hibernate
                bindsym e exit
                bindsym u mode "default" , exec gdmflexiserver
                bindsym p exec systemctl poweroff -i
                bindsym x mode "default" , exec $display_off
                # back to normal: Enter or Escape
                bindsym Return mode "default"
                bindsym Escape mode "default"
        }
        bindsym $mod+o mode $exit_mode

        # resize window (you can also use the mouse for that)
        mode "resize" {
                bindsym h resize shrink width  10 px or 10 ppt
                bindsym j resize grow   height 10 px or 10 ppt
                bindsym k resize shrink height 10 px or 10 ppt
                bindsym l resize grow   width  10 px or 10 ppt
                # back to normal: Enter or Escape or $mod+r
                bindsym Return mode "default"
                bindsym Escape mode "default"
                bindsym $mod+r mode "default"
        }
        bindsym $mod+r mode "resize"

        # Compositor for transparency
        exec --no-startup-id picom &

        # Start i3bar to display a workspace bar (plus the system information i3status
        # finds out, if available)
        bar {
                status_command i3status
        }
      '';
    };
  }
