{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../user/alacritty.nix
    ../../user/shells.nix
    ../../user/git.nix
  ];
  home = {
    username = "iv546";
    homeDirectory = "/home/iv546";
    stateVersion = "24.05";

    packages = [
      pkgs.alejandra

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

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;
    };
    sessionVariables = {
      # EDITOR = "emacs";
    };
  };
  programs.home-manager.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      # name = "Material-Black-Plum-Suru";
      name = "MB-Plum-Suru-GLOW";
      package = pkgs.material-black-colors;
    };
    cursorTheme = {
      name = "volantes_cursors";
      package = pkgs.volantes-cursors;
    };
  };
}
