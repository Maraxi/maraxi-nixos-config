{
  pkgs,
  setup,
  lib,
  ...
}:
{
  home.packages =
    let
      basic_pkgs = with pkgs; [
        # Default terminal for gtk-launch / wofi
        (pkgs.writeShellScriptBin "xdg-terminal-exec" ''exec ${pkgs.ghostty}/bin/ghostty +new-window -e "$@"'')

        (pkgs.symlinkJoin {
          name = "xdg-utils-and-alias";
          paths = [ pkgs.xdg-utils ];
          postBuild = "ln -s $out/bin/xdg-open $out/bin/open";
        })

        fastfetch
        tmux

        (pkgs.symlinkJoin {
          name = "feh";
          buildInputs = [ pkgs.makeWrapper ];
          paths = [ pkgs.feh ];
          postBuild = ''wrapProgram $out/bin/feh --append-flags "--no-fehbg"'';
        })

        telegram-desktop

        uv
        ruff
        ty

        jq
        yq

        lua
        stylua
        # cargo
        # zig

        htop
        btop

        fd
        pciutils
        wget
        lsof
        bat
        dust
        file

        (pkgs.symlinkJoin {
          name = "trans";
          buildInputs = [ pkgs.makeWrapper ];
          paths = [ pkgs.translate-shell ];
          postBuild = ''wrapProgram $out/bin/trans --append-flags "-engine bing"'';
        })

        nix-tree
        nvd

        atool
        zip
        unzip
        unar

        tty-clock

        treefmt
        nixfmt

        shellcheck
        shfmt
        shellharden

        pre-commit

        imagemagick

        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
      ];
      per_system_pkgs =
        if setup.isNixOS then
          with pkgs;
          [
            gcc
            gnumake
            python314
            python314Packages.ipython

            wev
            inxi
            usbutils
            parallel

            iw
            dig

            libfaketime
            libnotify

            fclones

            pavucontrol
            vlc

            glances
            ncdu

            gimp
            gdk-pixbuf
            webp-pixbuf-loader
            # For general HEIF container support (this includes the AVIF file format)
            libheif.bin # provides heif-thumbnailer (the program that generates HEIF thumbnails)
            libheif.out # provides heif.thumbnailer (allows for the viewing of HEIF thumbnails)
            ffmpeg-headless
            ffmpegthumbnailer

            glib
            nemo
            libreoffice-fresh
            evince
            pdfarranger
            gthumb

            thunderbird

            simple-scan

            gnome-maps
          ]
        else
          with pkgs;
          [
            util-linux

            python313
            python313Packages.ipython

            curl

            kubectl # for pycharm

            freerdp

            sqlcl

            podman
            kubernetes-helm
            openshift

            gh # github cli

            apache-directory-studio

            bluetuith
          ];
    in
    basic_pkgs ++ per_system_pkgs;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-enable-primary-paste = true;
      color-scheme = "prefer-dark";
    };
    "org/nemo/preferences" = {
      show-hidden-files = true;
      thumbnail-limit = lib.hm.gvariant.mkUint64 1073741824;
    };
    "org/cinnamon/desktop/applications/terminal" = {
      exec = "ghostty --working-directory=inherit"; # for nemo -> open in terminal
    };
  };
}
