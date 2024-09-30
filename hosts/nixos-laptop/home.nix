{...}: {
  imports = [
    ../../user
  ];

  programs.home-manager.enable = true;

  home = {
    username = "stefan";
    homeDirectory = "/home/stefan";
    stateVersion = "24.05";
  };
}
