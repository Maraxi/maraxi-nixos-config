{ pkgs, ... }: {
  # Only install android-tools on demand
  # environment.systemPackages = [ pkgs.android-tools ];
  users.users.stefan.extraGroups = [ "adbusers" ];
}
