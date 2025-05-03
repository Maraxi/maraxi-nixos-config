# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  # config,
  lib,
  pkgs,
  config,
  # outputs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  # nixpkgs.overlays = [outputs.overlays.trunk-packages];
  nixpkgs.config = {
    # allowBroken = true;
    # allowUnfree = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "keymapp" # allow non-free keymapp for voyager
        "nvidia-x11"
        "nvidia-settings"
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ];
  };

  system = {
    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    stateVersion = "24.11";
    # autoUpgrade = {
    #   enable = true;
    #   flake = inputs.self.outPath; # TOFix use flake
    #   dates = "weekly";
    # };
  };
}
