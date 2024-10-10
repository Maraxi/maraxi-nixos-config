{
  setup,
  pkgs,
  ...
}: {
  # programs.neovim = {
  # enable = true;
  # package = let
  # nvim_pkgs =
  # if setup.isNixOS
  # then pkgs
  # else
  # import (builtins.fetchTarball {
  # name = "pkgs-neovim-0.9.5";
  # url = "https://github.com/NixOS/nixpkgs/archive/0c19708cf035f50d28eb4b2b8e7a79d4dc52f6bb.tar.gz";
  # sha256 = "0ngw2shvl24swam5pzhcs9hvbwrgzsbcdlhpvzqc7nfk8lc28sp3";
  # }) {inherit (pkgs) system;};
  # in
  # nvim_pkgs.neovim;
  # };
  home.packages = let
    nvim_pkgs =
      if setup.isNixOS
      then pkgs
      else
        import (builtins.fetchTarball {
          name = "pkgs-neovim-0.9.5";
          url = "https://github.com/NixOS/nixpkgs/archive/0c19708cf035f50d28eb4b2b8e7a79d4dc52f6bb.tar.gz";
          sha256 = "0ngw2shvl24swam5pzhcs9hvbwrgzsbcdlhpvzqc7nfk8lc28sp3";
        }) {inherit (pkgs) system;};
  in [nvim_pkgs.neovim];
}
