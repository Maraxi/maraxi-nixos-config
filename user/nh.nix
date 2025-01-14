{setup, ...}: {
  programs.nh = {
    enable = true;
    flake = "/home/${setup.username}/${
      if setup.isNixOS
      then "nixconfig"
      else ".config/home-manager"
    }";
  };
}
