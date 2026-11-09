{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./wifi-tdls.nix
  ];

  nixpkgs.config = {
    # allowBroken = true;
    allowUnfreePackages = [
      "keymapp" # allow non-free keymapp for voyager
      "nvidia-settings"
      "nvidia-x11"
      "steam"
      "steam-unwrapped"
    ];
    allowUnfreePredicate = pkgs._cuda.lib.allowUnfreeCudaPredicate;
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
