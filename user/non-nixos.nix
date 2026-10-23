{
  config,
  lib,
  pkgs,
  ...
}:
let
  nvidia = config.targets.genericLinux.gpu.nvidia;

  # The nix userspace driver must match the kernel module installed by apt exactly.
  # Run this after every apt upgrade that touches nvidia packages (also runs on `home-manager switch`).
  checkNvidiaMatch = pkgs.writeShellScriptBin "check-nvidia-nix-match" ''
    pinned="${nvidia.version}"

    if [[ ! -r /proc/driver/nvidia/version ]]; then
      echo "nvidia kernel module is not loaded, nothing to compare"
      exit 0
    fi

    loaded=$(head -n1 /proc/driver/nvidia/version | grep -oE '[0-9]{3}\.[0-9]{2,3}(\.[0-9]{2,3})?' | head -n1)

    if [[ $loaded == "$pinned" ]]; then
      echo "nvidia driver: kernel module $loaded matches the nix userspace driver"
      exit 0
    fi

    cat >&2 <<MSG
    WARNING: nvidia kernel module is $loaded but home-manager pins $pinned.
    Hyprland will not start properly until they match (GNOME is not affected).
    Update targets.genericLinux.gpu.nvidia in ~/.config/home-manager/user/non-nixos.nix:
      version = "$loaded";
      sha256  = <hash from the command below>
        nix store prefetch-file --json https://download.nvidia.com/XFree86/Linux-x86_64/$loaded/NVIDIA-Linux-x86_64-$loaded.run
    then run home-manager switch and the "sudo .../non-nixos-gpu-setup" it asks for.
    MSG
    exit 1
  '';
in
{
  # https://github.com/nix-community/home-manager/blob/master/docs/manual/usage/gpu-non-nixos.md
  targets.genericLinux = {
    enable = true;
    # The external monitors of this laptop are wired to the nvidia gpu, so Hyprland needs the
    # nvidia GBM/EGL libs in /run/opengl-driver (mesa alone only drives the internal panel).
    gpu.nvidia = {
      enable = true;
      # Check version in
      # nvidia-smi -q | grep "Driver Version"
      version = "595.99.02";
      sha256 = "sha256-6HR3lYv3YwcFSTJL1a1slI66btIQ5EAFs+/4SUD24ew=";
    };
  };

  home.packages = [ checkNvidiaMatch ];
  home.activation.checkNvidiaDriverMatch = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${lib.getExe checkNvidiaMatch} || true
  '';

  nix.assumeXdg = true;
}
