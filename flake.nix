{
  description = "flake for stefan-nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nixvim.url = "github:nix-community/nixvim";
    # nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    # nixvim,
    ...
  }: {
    nixosConfigurations = {
      stefan-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./greetd.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.stefan = {pkgs, ...}: {
              home.username = "stefan";
              home.homeDirectory = "/home/stefan";
              home.keyboard = {
                layout = "de";
                variant = "nodeadkeys";
                options = "caps:escape_shifted_capslock";
              };
              home.packages = with pkgs; [
                cinnamon.nemo
                librewolf
                thunderbird
                keepassxc
                mako # wayland notification daemon
                sway-contrib.grimshot
                # grim
                # slurp # wayland screenshots
                # wf-recorder
                # kanshi # hot switching output profiles
                wl-clipboard # wayland clipboard
                # shotman # wayland screenshots
                # flameshot
                simple-scan
                tree
                ripgrep
                fd
                feh
                glances
                python313
                fzf
                neofetch
                htop
                fclones
                pciutils
                wget
                lsof
                alejandra
                pavucontrol
                # hello
                appimage-run
              ];
              home.sessionPath = ["$HOME/bin"];

              gtk = {
                enable = true;
                # gtk3.extraConfig.gtk-decoration-layout = "menu:";
                # theme.package = pkgs.solarc-gtk-theme;
                # theme.name = "SolArc-Dark";
                # theme = {
                # name = "Storm-B";
                # package = pkgs.tokyonight-gtk-theme;
                # };
                # iconTheme.name = "Tokyonight-Moon";
                # cursorTheme = {
                # name = "gtkCursorTheme";
                # package = pkgs.bibata-cursors;
                # };
              };
              # home.sessionVariables.GTK_THEME = "Tokyonight-Moon";
              programs.bash.enable = true;
              programs.nushell = {
                enable = true;
                # for editing directly to config.nu
                extraConfig = ''
                  # let carapace_completer = {|spans|
                  # carapace $spans.0 nushell $spans | from json
                  # }
                  $env.config = {
                   show_banner: false,
                   # completions: {
                   # case_sensitive: false # case-sensitive completions
                   # quick: true    # set to false to prevent auto-selecting completions
                   # partial: true    # set to false to prevent partial filling of the prompt
                   # algorithm: "fuzzy"    # prefix or fuzzy
                   # external: {
                   # set to false to prevent nushell looking into $env.PATH to find more suggestions
                       # enable: true
                   # set to lower can improve completion performance at the cost of omitting some options
                       # max_results: 100
                       # completer: $carapace_completer # check 'carapace_completer'
                     # }
                   # }
                  }
                  # $env.PATH = ($env.PATH |
                  # split row (char esep) |
                  # prepend /home/myuser/.apps |
                  # append /usr/bin/env
                  # )
                '';
                # shellAliases = {
                # vi = "hx";
                # vim = "hx";
                # nano = "hx";
                # };
              };
              # programs.carapace = {
              # enable = true;
              # enableNushellIntegration = true;
              # };
              programs.git = {
                enable = true;
                userName = "Maraxi";
                userEmail = "Maraxi@users.noreply.github.com";
                extraConfig = {
                  init.defaultBranch = "main";
                };
              };
              # programs.ssh = {
              # enable = true;
              # matchBlocks = {
              # "github.com" = {
              # hostname = "github.com";
              # identityFile = "/home/stefan/.ssh/id_ed25519_github";
              # };
              # };
              # };

              programs.home-manager.enable = true;
              # programs.nixvim = {
              # opts = {
              # number = true;
              # };
              # };
              programs.alacritty.enable = true;
              programs.alacritty.settings = {
                colors.bright = {
                  black = "#575656";
                  blue = "#82aaff";
                  cyan = "#7fdbca";
                  green = "#22da6e";
                  magenta = "#c792ea";
                  red = "#ef5350";
                  white = "#ffffff";
                  yellow = "#ffeb95";
                };
                colors.cursor = {
                  cursor = "#d6deeb";
                  text = "#011627";
                };
                colors.normal = {
                  black = "#011627";
                  blue = "#82aaff";
                  cyan = "#21c7a8";
                  green = "#22da6e";
                  magenta = "#c792ea";
                  red = "#ef5350";
                  white = "#ffffff";
                  yellow = "#c5e478";
                };
                colors.primary = {
                  background = "#011627";
                  foreground = "#d6deeb";
                };
                colors.selection = {
                  background = "#1b90dd";
                };
                keyboard.bindings = [
                  {
                    action = "SpawnNewInstance";
                    key = "Return";
                    mods = "Control|Shift";
                  }
                ];
                window = {
                  dynamic_title = true;
                  opacity = 0.8;
                };
                window.padding = {
                  x = 4;
                  y = 0;
                };
              };
              programs.zoxide = {
                enable = true;
                enableBashIntegration = true;
                options = ["--cmd" "cd"];
              };
              programs.fzf = {
                enable = true;
                enableBashIntegration = true;
              };
              programs.starship = {
                enable = true;
                enableBashIntegration = true;
              };

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

              home.stateVersion = "24.05";
            };
          }
        ];
      };
    };
  };
}
