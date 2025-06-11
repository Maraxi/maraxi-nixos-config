{pkgs, ...}: {
  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix

    neovim
    vim
    git
  ];
}
