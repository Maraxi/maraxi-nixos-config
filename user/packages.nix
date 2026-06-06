{
  pkgs,
  setup,
  lib,
  ...
}: {
  home.packages = let
    basic_pkgs = with pkgs; [
      # Default terminal for gtk-launch / wofi
      (pkgs.writeShellScriptBin "xdg-terminal-exec" ''exec ${pkgs.ghostty}/bin/ghostty +new-window -e "$@"'')

      fastfetch
      tmux

      feh

      telegram-desktop

      uv
      ruff
      ty

      jq
      yq

      lua
      # cargo
      # zig

      glances
      htop
      btop

      fd
      difftastic
      pciutils
      wget
      lsof
      bat
      dust
      file

      (pkgs.symlinkJoin {
        name = "trans";
        buildInputs = [pkgs.makeWrapper];
        paths = [pkgs.translate-shell];
        postBuild = ''
          wrapProgram $out/bin/trans \
            --append-flags "-engine bing"
        '';
      })

      nix-tree
      nvd

      atool
      zip
      unzip
      unar

      tty-clock

      nixfmt
      alejandra
      shellcheck

      pre-commit

      imagemagick
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];
    per_system_pkgs =
      if setup.isNixOS
      then
        with pkgs; [
          gcc
          gnumake
          python314
          python314Packages.ipython

          inxi
          usbutils
          parallel

          dig

          libfaketime
          libnotify

          fclones

          pavucontrol
          vlc
          mplayer

          ncdu

          gimp
          gdk-pixbuf
          webp-pixbuf-loader
          # For general HEIF container support (this includes the AVIF file format)
          libheif.bin # provides heif-thumbnailer (the program that generates HEIF thumbnails)
          libheif.out # provides heif.thumbnailer (allows for the viewing of HEIF thumbnails)
          ffmpeg-headless
          ffmpegthumbnailer

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
        with pkgs; [
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
    "org/nemo/preferences" = {
      show-hidden-files = true;
      thumbnail-limit = lib.hm.gvariant.mkUint64 1073741824;
    };
  };
}
