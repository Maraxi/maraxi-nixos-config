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

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };

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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];

  networking.hostName = "stefan-nixos";

  # wayland-related
  security.polkit.enable = true;

  # Enable sound.
  # sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # automount / unmount drives
  services.devmon.enable = true; # automatic mounting of drives
  services.gvfs.enable = true; # userspace virtual filesystem
  services.udisks2.enable = true; # DBus service for applications to query storage devices

  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [
    neovim
    vim
    git
  ];

  services.gnome.gnome-keyring.enable = true;

  fonts = {
    packages = with pkgs; [
      nerd-fonts.droid-sans-mono
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Source Han Serif"];
      sansSerif = ["Noto Sans" "Source Han Sans"];
    };
  };

  programs.dconf.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    # pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };
  # services.dbus.packages = [ pkgs.gcr ];
  # services.pcscd.enable = true;

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # optimise = {
    #   automatic = true;
    #   dates = ["weekly"];
    # };
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
