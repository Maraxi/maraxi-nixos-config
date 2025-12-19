{
  pkgs,
  config,
  setup,
  lib,
  ...
}: {
  home.packages = let
    basic_pkgs = with pkgs; [
      neofetch

      feh

      uv
      ruff
      ty

      jq
      yq

      cargo
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

      atool
      zip
      unzip
      unar

      tty-clock

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
          python313
          python313Packages.ipython

          inxi
          usbutils

          dig

          libfaketime
          libnotify

          fclones

          pavucontrol
          vlc

          ncdu

          telegram-desktop

          nemo
          libreoffice
          evince
          pdfarranger
          gthumb

          thunderbird

          simple-scan

          keepassxc

          gnome-maps
        ]
      else
        with pkgs; [
          kubectl # for pycharm

          podman
          kubernetes-helm

          gh # github cli
        ];
  in
    basic_pkgs ++ per_system_pkgs;

  home.file = {
    "bin/create-venv".source = config.lib.meta.mkMutableSymlink dotfiles/bin/create-venv;
  };

  dconf.settings = {
    "org/nemo/preferences" = {
      show-hidden-files = true;
      thumbnail-limit = lib.hm.gvariant.mkUint64 1073741824;
    };
  };
}
