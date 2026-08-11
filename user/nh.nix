{ config, ... }: {
  programs.nh = {
    enable = true;
    flake = config.lib.meta.flakeDir;
  };
}
