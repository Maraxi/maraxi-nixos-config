{pkgs, ...}: {
  nix.settings.trusted-users = ["stefan"];

  users.groups = {
    plugdev = {};
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stefan = {
    isNormalUser = true;
    description = "Stefan";
    extraGroups = ["wheel" "networkmanager" "input" "audio" "video" "scanner" "lp" "plugdev"];
    packages = with pkgs; [];
    # shell = pkgs.nushell;
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [];
  };
}
