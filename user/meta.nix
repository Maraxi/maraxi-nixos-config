{
  config,
  inputs,
  lib,
  setup,
  ...
}:
{
  _module.args = rec {
    flakeDir = "${config.home.homeDirectory}/${
      if setup.isNixOS then "nixconfig" else ".config/home-manager"
    }";
    mkMutableSymlink =
      path:
      config.lib.file.mkOutOfStoreSymlink (
        flakeDir + lib.removePrefix (toString inputs.self) (toString path)
      );
    mutableLink = path: { source = mkMutableSymlink path; };
  };
}
