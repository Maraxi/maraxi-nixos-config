{pkgs, ...}: {
  home.packages = with pkgs; [
    nemo
    xfce.thunar
    librewolf
    thunderbird
    keepassxc
    simple-scan
    feh

    appimage-run
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
}
