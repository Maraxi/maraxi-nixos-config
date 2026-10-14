{
  config,
  inputs,
  lib,
  setup,
  ...
}:
{
  lib.meta = {
    flakeDir = "${config.home.homeDirectory}/${
      if setup.isNixOS then "nixconfig" else ".config/home-manager"
    }";
    mkMutableSymlink =
      path:
      config.lib.file.mkOutOfStoreSymlink (
        config.lib.meta.flakeDir + lib.removePrefix (toString inputs.self) (toString path)
      );
  };

  _module.args = {
    flakeDir = "${config.home.homeDirectory}/${
      if setup.isNixOS then "nixconfig" else ".config/home-manager"
    }";
    mutableLink = path: {
      source = config.lib.meta.mkMutableSymlink path;
    };
  };
}
