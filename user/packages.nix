{
  pkgs,
  setup,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "pycharm-professional"
    ];

  home.packages = let
    basic_pkgs = with pkgs; [
      nvim-pkg

      keepassxc
      feh

      pavucontrol

      python313
      uv

      glances
      htop
      btop

      gcc
      gnumake
      tree
      fd
      difftastic
      neofetch
      fclones
      pciutils
      wget
      lsof
      atool
      unzip
      zip
      alejandra

      pre-commit

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
          appimage-run
          nemo
        ]
      else
        with pkgs; [
          jetbrains.pycharm-professional
        ];
    all_packages = basic_pkgs ++ full_install_pkgs;
  in
    all_packages;

  dconf.settings = {
    "org/nemo/preferences" = {
      show-hidden-files = true;
      thumbnail-limit = lib.hm.gvariant.mkUint64 1073741824;
    };
  };

  programs.lesspipe.enable = true;

  home.file = {
    ".config/lesskey".source = dotfiles/lesskey;
    # ".config/htop/htoprc".source = dotfiles/htoprc;
  };
}
