{
  config,
  pkgs,
  ...
}: {
  imports = [
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

  programs.bash.enable = true;
  programs.readline = {
    enable = true;
    variables = {
      completion-ignore-case = true;
      match-hidden-files = true;
      mark-symlinked-directories = true;
    };
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = ["--cmd" "cd"];
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/iv546/etc/profile.d/hm-session-vars.sh
  #

  # Let Home Manager install and manage itself.
}
