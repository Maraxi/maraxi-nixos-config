# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../system/greetd.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    # extraOptions = ''
    # experimental-features = nix-command flakes
    # '';
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "stefan-nixos";
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
    options = "caps:escape_shifted_capslock, compose:sclk";
  };
  console.useXkbConfig = true; # use xkb.options in tty.

  # wayland-related
  security.polkit.enable = true;
  # hardware.opengl.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable sane for scanner
  hardware.sane.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # Enable sound.
  sound.enable = false;
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;
  # hardware.pulseaudio.package = pkgs.pulseaudioFull;
  # nixpkgs.config = {
  # pulseaudio = true;
  # allowBroken = true;
  # allowUnfree = true;
  # };
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stefan = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "video" "scanner" "lp"];
    # shell = pkgs.nushell;
    shell = pkgs.bash;
  };

  environment.systemPackages = with pkgs; [
    neovim
    vim
    git
  ];

  services.gnome.gnome-keyring.enable = true;

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["DroidSansMono"];})
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Source Han Serif"];
      sansSerif = ["Noto Sans" "Source Han Sans"];
    };
  };

  # programs.dconf.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.auto-optimise-store = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
  };

  system = {
    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    stateVersion = "23.11"; # Did you read the comment?
    # # autoUpgrade = {
    # enable = true;
    # flake = inputs.self.outPath; # TOFix use flake
    # dates = "weekly";
    # };
  };
}
