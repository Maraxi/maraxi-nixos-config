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
      trusted-users = ["stefan"];
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
      ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];

  networking.hostName = "stefan-nixos";
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  # TODO: use central keyboard setting from flake.nix
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
    options = "caps:escape_shifted_capslock, compose:sclk";
  };
  console.useXkbConfig = true; # use xkb.options in tty.

  # wayland-related
  security.polkit.enable = true;
  # hardware.opengl.enable = true;

  #nvidia
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    # powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [brlaser];
  };
  hardware.printers.ensurePrinters = [
    {
      name = "Brother_MFC_L2710DW_series";
      deviceUri = "dnssd://Brother%20MFC-L2710DW%20series._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-3c2af45641b1";
      model = "drv:///brlaser.drv/brl2710w.ppd";
      ppdOptions = {
        PageSize = "A4";
        Duplex = "DuplexNoTumble";
      };
    }
  ];
  # Enable sane for scanner
  hardware.sane.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

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

  # udev rules for voyager keyboard
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stefan = {
    isNormalUser = true;
    description = "Stefan";
    extraGroups = ["wheel" "networkmanager" "input" "audio" "video" "scanner" "lp"];
    packages = with pkgs; [];
    # shell = pkgs.nushell;
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrOG3FrTlVDOj5TTe5njEB5JUgJ8jum7GdXGK3wNTMeqogCBd1X0K7vTCw2GikgWeUzjN1BM4WeSIlcjyQWGePIVzUlFUhj98h3N9jsQ6T1W7Gyq6vOF35w3cDQTmLYHgFWeDl0llJzj8PW4iJGhVClaVZSyhEVhc78d8xOLadaDK9IljIHaULgDYcZg4Gx+TwcnNmYRvg9oY5RdPft24IJqFPx+xTRM/suw19uXGtGXFUZ316knTkzQFwt6kjVFg7/S0L8J1G+Vo/uCD8DieM1ZGk2WaFaGsrVOdFp1YKCB/iAJFAnR3GFJ6DsPI9UiwsucY1YkbBrVV7MF18Xug/L4ykya7+nxQ0x5iJencHTHwkT14pwfMTdLvZxrLRgxhS/F0q81z+0qWTrx5AS46gTZLlZgHDFSD0rgBE9aZWzZf1x2SxXWKJoY6kpe5WwroRYcyM2ByzXIjrHIvtKdQPmJswzGEFq+/okWw4v5EHdrPd81WLpc6s4ilas6bWjcCObRRux2WA5iS530Xv/G8snacohl21dZ20+L66fzP44410V48kQPcy2DIiDdy1rzj8iRDbn+DHVidy2CDd4Grhhw9J8of59HxWxd02FE7AAlzvsiDdcvKxvzE2fxeBVJCYatfnL+fn7ptcsqLEYDh6PNZyOunto5J4sJfi5ibYcQ== generated by Keepass2Android"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINH9SWAyoJv7govQkrJRcir2uMV9b8fO+87Y8oN8IJXL ssh key from raspberrypi to fujitsu"
    ];
  };

  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [
    neovim
    vim
    git
  ];

  environment.etc = {
    "papersize".text = "a4";
  };

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

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [36969];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [8000];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
