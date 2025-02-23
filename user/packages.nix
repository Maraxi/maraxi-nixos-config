{
  pkgs,
  setup,
  lib,
  ...
}: {
  home.packages = let
    basic_pkgs = with pkgs; [
      keepassxc

      feh
      pavucontrol

      vlc

      python313
      python313Packages.ipython
      uv
      ruff

      # cargo
      zig

      glances
      htop
      btop

      dust
      ncdu

      libfaketime
      gcc
      gnumake
      fd
      difftastic
      fclones
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

      evince
      pdfarranger
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
          firefox
          thunderbird
          simple-scan
          nemo
          libreoffice
        ]
      else
        with pkgs; [
          jetbrains.pycharm-professional
          kubectl # for pycharm

          podman
          kubernetes-helm

          coreutils
          glibc

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
