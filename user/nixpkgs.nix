{lib, ...}: {
  nixpkgs.overlays = [
    # outputs.overlays.selective-update
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "pycharm-professional"
      "keymapp"
      "sqlcl"
    ];
}
