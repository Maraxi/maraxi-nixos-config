{...}: {
  programs.adb.enable = true;
  users.users.stefan.extraGroups = ["adbusers"];
}
