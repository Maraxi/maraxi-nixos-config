{ pkgs, setup, ... }:
let
  basicPkgs = with pkgs; [
    # Default terminal for gtk-launch / wofi
    (writeShellScriptBin "xdg-terminal-exec" ''exec ${ghostty}/bin/ghostty +new-window -e "$@"'')

    (symlinkJoin {
      name = "xdg-utils-and-alias";
      paths = [ xdg-utils ];
      postBuild = "ln -s $out/bin/xdg-open $out/bin/open";
    })

    nemo
    fastfetch
    wiremix

    swayimg

    telegram-desktop

    opencode

    prek
    devenv
    treefmt
    eclint

    jq
    yq-go

    inxi
    htop
    btop

    fd
    pciutils
    wget
    lsof
    bat
    dust
    file
    parallel

    (symlinkJoin {
      name = "trans";
      buildInputs = [ makeWrapper ];
      paths = [ translate-shell ];
      postBuild = ''wrapProgram $out/bin/trans --append-flags "-engine bing"'';
    })

    nix-tree
    dix

    atool
    zip
    unzip
    unar

    tty-clock

    imagemagick

    bluetuith
  ];

  nixosPkgs = with pkgs; [
    gcc
    gnumake

    wev
    usbutils

    iw
    dig

    libfaketime
    libnotify

    fclones

    vlc

    ncdu

    gimp
    gdk-pixbuf
    webp-pixbuf-loader
    # For general HEIF container support (this includes the AVIF file format)
    libheif.bin # provides heif-thumbnailer (the program that generates HEIF thumbnails)
    libheif.out # provides heif.thumbnailer (allows for the viewing of HEIF thumbnails)
    ffmpeg-headless
    ffmpegthumbnailer

    glib
    libreoffice-stable
    evince
    pdfarranger
    gthumb

    thunderbird

    simple-scan

    gnome-maps
  ];

  nonNixosPkgs = with pkgs; [
    util-linux

    curl

    pycharm
    kubectl # for pycharm

    freerdp

    sqlcl

    kubernetes-helm
    openshift

    gh # github cli

    apache-directory-studio

    flameshot

    onedrive
    scribus
  ];
in
{
  home.packages = basicPkgs ++ (if setup.isNixOS then nixosPkgs else nonNixosPkgs);
}
