{lib, ...}: {
  nixpkgs.overlays = [
    # outputs.overlays.selective-update
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "keymapp"
      # "nvidia-x11"
      "pycharm-professional"
      "sqlcl"
    ];
  # nixpkgs.config.nvidia.acceptLicense = true;
}
