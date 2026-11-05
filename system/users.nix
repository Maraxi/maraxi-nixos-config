{ pkgs, ... }: {
  users.groups = {
    plugdev = { };
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stefan = {
    isNormalUser = true;
    description = "Stefan";
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "audio"
      "video"
      "scanner"
      "lp"
      "plugdev"
    ];
    shell = pkgs.bash;
  };
}
