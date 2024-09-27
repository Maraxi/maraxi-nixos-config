{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../user/alacritty.nix
    ../../user/environment.nix
    ../../user/shells.nix
    ../../user/git.nix
    ../../user/gtk.nix
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "01dkfr9wq3ib5hlyq9zq662mp0jl42fw3f6gd2qgdf8l8ia78j7i";
    })
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

  nixGL.prefix = "${inputs.nixGL.packages."${pkgs.system}".nixGLIntel}/bin/nixGLIntel";
  programs.alacritty.package = config.lib.nixGL.wrap pkgs.alacritty;
}
