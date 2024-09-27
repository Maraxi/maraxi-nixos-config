{
  pkgs,
  setup,
  ...
}: {
  home.packages = let
    basic_pkgs = with pkgs; [
      nemo
      keepassxc
      feh

      pavucontrol

      python313

      glances
      htop
      btop

      gcc
      gnumake
      tree
      ripgrep
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
        ]
      else [];
    all_packages = basic_pkgs ++ full_install_pkgs;
  in
    all_packages;
}
