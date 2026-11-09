{
  lib,
  pkgs,
  setup,
  ...
}:
let
  basicPkgs = with pkgs; [
    # Launchers and integration
    # Default terminal for gtk-launch / wofi
    (writeShellScriptBin "xdg-terminal-exec" ''exec ${lib.getExe ghostty} +new-window -e "$@"'')
    xdg-utils
    (writeShellScriptBin "open" ''exec ${lib.getExe' xdg-utils "xdg-open"} "$@"'')

    # desktop apps
    nemo
    swayimg
    telegram-desktop
    wiremix
    bluetuith

    # Dev tooling
    opencode
    prek
    devenv
    treefmt
    eclint
    jq
    yq-go

    # System info and monitoring
    fastfetch
    inxi
    htop
    btop
    pciutils
    lsof
    nix-tree

    # File tools
    fd
    bat
    dust
    file
    parallel
    wget

    # Archives
    atool
    zip
    unzip
    unar

    # Misc
    tty-clock
    translate-shell
  ];

  nixosPkgs = with pkgs; [
    # Build tools
    gcc
    gnumake

    # Hardware and network diagnostics
    wev
    usbutils
    iw
    dig

    # Utilities
    dix # non-NixOS hosts get a wrapper from non-nixos/dix.nix
    libfaketime
    libnotify
    fclones
    ncdu

    # Media and thumbnails
    imagemagick
    vlc
    ffmpeg-headless
    ffmpegthumbnailer
    gdk-pixbuf
    webp-pixbuf-loader
    # For general HEIF container support (this includes the AVIF file format)
    libheif.bin # provides heif-thumbnailer (the program that generates HEIF thumbnails)
    libheif.out # provides heif.thumbnailer (allows for the viewing of HEIF thumbnails)

    # Documents and desktop
    glib # gio / gsettings
    libreoffice-stable
    evince
    pdfarranger
    gthumb
    simple-scan
    thunderbird
    gnome-maps
  ];

  nonNixosPkgs = with pkgs; [
    util-linux
    curl

    # Dev / work
    pycharm
    kubectl # for pycharm
    sqlcl
    kubernetes-helm
    openshift
    gh # github cli
    apache-directory-studio

    # desktop
    freerdp
    flameshot
    onedrive
    scribus
  ];
in
{
  home.packages = basicPkgs ++ (if setup.isNixOS then nixosPkgs else nonNixosPkgs);
}
