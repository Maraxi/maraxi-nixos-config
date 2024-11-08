{setup, ...}: {
  programs.nh = {
    enable = true;
    clean.enable = setup.isNixOS;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/${setup.username}/${
      if setup.isNixOS
      then "nixconfig"
      else ".home/home-manager"
    }";
  };
}
