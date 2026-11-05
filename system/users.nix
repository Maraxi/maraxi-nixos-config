{ pkgs, ... }: {
  users.groups = {
    plugdev = { };
    # avahi's D-Bus policy refers to it, NixOS does not create it (dbus-broker logs an invalid group-name otherwise)
    netdev = { };
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
