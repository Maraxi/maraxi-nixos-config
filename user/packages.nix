{
  pkgs,
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

      translate-shell

      nix-tree

      atool
      zip
      unzip
      unar

      tty-clock

      alejandra

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

          libfaketime
          libnotify

          fclones

          pavucontrol
          vlc

          # dust
          ncdu

          nemo
          libreoffice
          evince
          pdfarranger
          gthumb

          firefox
          thunderbird

          simple-scan

          keepassxc
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

  dconf.settings = {
    "org/nemo/preferences" = {
      show-hidden-files = true;
      thumbnail-limit = lib.hm.gvariant.mkUint64 1073741824;
    };
  };
}
