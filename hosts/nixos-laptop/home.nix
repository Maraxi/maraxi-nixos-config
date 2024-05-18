{
  pkgs,
  inputs,
  ...
}:
# let
# nixvim = import (builtins.fetchGit {
# url = "https://github.com/nix-community/nixvim";
# If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
# ref = "nixos-23.05";
# });
# in
{
  imports = [
    ../../user/alacritty.nix
    ../../user/sway.nix
    # nixvim.homeManagerModules.nixvim
  ];
  # inputs.nixvim.homeManagermodules.nixvim.enable = true;
  programs.nixvim.enable = true;
  programs.nixvim = {
    opts = {
      number = true;
      relativenumber = true;
      list = true;
    };
  };

  # programs.nixvim.enable = true;
  home.username = "stefan";
  home.homeDirectory = "/home/stefan";
  home.keyboard = {
    layout = "de";
    variant = "nodeadkeys";
    options = "caps:escape_shifted_capslock";
  };
  home.packages = with pkgs; [
    cinnamon.nemo
    librewolf
    thunderbird
    keepassxc
    mako # wayland notification daemon
    sway-contrib.grimshot
    # grim
    # slurp # wayland screenshots
    # wf-recorder
    # kanshi # hot switching output profiles
    wl-clipboard # wayland clipboard
    # shotman # wayland screenshots
    # flameshot
    simple-scan
    tree
    ripgrep
    fd
    feh
    glances
    python313
    fzf
    neofetch
    htop
    fclones
    pciutils
    wget
    lsof
    alejandra
    pavucontrol
    # hello
    appimage-run
  ];
  home.sessionPath = ["$HOME/bin"];

  gtk = {
    enable = true;
    # gtk3.extraConfig.gtk-decoration-layout = "menu:";
    # theme.package = pkgs.solarc-gtk-theme;
    # theme.name = "SolArc-Dark";
    # theme = {
    # name = "Storm-B";
    # package = pkgs.tokyonight-gtk-theme;
    # };
    # iconTheme.name = "Tokyonight-Moon";
    # cursorTheme = {
    # name = "gtkCursorTheme";
    # package = pkgs.bibata-cursors;
    # };
  };
  # home.sessionVariables.GTK_THEME = "Tokyonight-Moon";
  programs.bash.enable = true;
  programs.nushell = {
    enable = true;
    # for editing directly to config.nu
    extraConfig = ''
      # let carapace_completer = {|spans|
      # carapace $spans.0 nushell $spans | from json
      # }
      $env.config = {
       show_banner: false,
       # completions: {
       # case_sensitive: false # case-sensitive completions
       # quick: true    # set to false to prevent auto-selecting completions
       # partial: true    # set to false to prevent partial filling of the prompt
       # algorithm: "fuzzy"    # prefix or fuzzy
       # external: {
       # set to false to prevent nushell looking into $env.PATH to find more suggestions
           # enable: true
       # set to lower can improve completion performance at the cost of omitting some options
           # max_results: 100
           # completer: $carapace_completer # check 'carapace_completer'
         # }
       # }
      }
      # $env.PATH = ($env.PATH |
      # split row (char esep) |
      # prepend /home/myuser/.apps |
      # append /usr/bin/env
      # )
    '';
    # shellAliases = {
    # vi = "hx";
    # vim = "hx";
    # nano = "hx";
    # };
  };
  # programs.carapace = {
  # enable = true;
  # enableNushellIntegration = true;
  # };
  programs.git = {
    enable = true;
    userName = "Maraxi";
    userEmail = "Maraxi@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  # programs.ssh = {
  # enable = true;
  # matchBlocks = {
  # "github.com" = {
  # hostname = "github.com";
  # identityFile = "/home/stefan/.ssh/id_ed25519_github";
  # };
  # };
  # };

  programs.home-manager.enable = true;
  # programs.nixvim = {
  # opts = {
  # number = true;
  # };
  # };
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

  home.stateVersion = "24.05";
}
