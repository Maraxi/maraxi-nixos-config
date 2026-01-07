{pkgs, ...}: {
  environment.systemPackages = [pkgs.android-tools];
  users.users.stefan.extraGroups = ["adbusers"];
}
