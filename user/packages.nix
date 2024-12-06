{
  pkgs,
  setup,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "pycharm-professional"
      "keymapp"
    ];

  home.packages = let
    basic_pkgs = with pkgs; [
      feh
      keepassxc
      pavucontrol

      python313
      uv
      ruff

      cargo
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

      atool
      unzip
      zip

      alejandra

      pre-commit

      keymapp

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
    full_install_pkgs =
      if setup.isNixOS
      then
        with pkgs; [
          librewolf
          thunderbird
          simple-scan
          nemo
        ]
      else
        with pkgs; [
          jetbrains.pycharm-professional
          kubectl # for pycharm
          coreutils
        ];
  in
    basic_pkgs ++ full_install_pkgs;

  dconf.settings = {
    "org/nemo/preferences" = {
      show-hidden-files = true;
      thumbnail-limit = lib.hm.gvariant.mkUint64 1073741824;
    };
  };
}
