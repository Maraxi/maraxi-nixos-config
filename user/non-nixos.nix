{
  config,
  flakeDir,
  lib,
  pkgs,
  ...
}:
let
  nvidia = config.targets.genericLinux.gpu.nvidia;
  pinFile = "${flakeDir}/user/non-nixos.nix";

  loadedVersion = ''head -n1 /proc/driver/nvidia/version | grep -oE '[0-9]{3}\.[0-9]{2,3}(\.[0-9]{2,3})?' | head -n1'';

  # The nix userspace driver must match the kernel module installed by apt exactly.
  # Run this after every apt upgrade that touches nvidia packages (also runs on `home-manager switch`).
  checkNvidiaMatch = pkgs.writeShellScriptBin "check-nvidia-nix-match" ''
    pinned="${nvidia.version}"

    if [[ ! -r /proc/driver/nvidia/version ]]; then
      echo "nvidia kernel module is not loaded, nothing to compare"
      exit 0
    fi

    loaded=$(${loadedVersion})

    if [[ $loaded == "$pinned" ]]; then
      echo "nvidia driver: kernel module $loaded matches the nix userspace driver"
      exit 0
    fi

    # same colors as home-manager's errorEcho / warnEcho, only on a terminal (NO_COLOR is respected)
    red="" yellow="" reset=""
    if [[ -t 2 && ! -v NO_COLOR && ''${TERM:-dumb} != dumb ]]; then
      red=$'\e[1;31m' yellow=$'\e[33m' reset=$'\e[0m'
    fi

    echo "''${red}WARNING: nvidia kernel module is $loaded but home-manager pins $pinned.''${reset}" >&2
    cat >&2 <<MSG
    ''${yellow}Hyprland will not start properly until they match (GNOME is not affected).
    Update the pin in ${pinFile}, then apply it:
      update-nvidia-pin
      home-manager switch
      sudo .../non-nixos-gpu-setup   (the command the switch prints)''${reset}
    MSG
    exit 1
  '';

  # Sets version and sha256 of the pin above to the driver the kernel module has (or the version given as argument).
  updateNvidiaPin = pkgs.writeShellScriptBin "update-nvidia-pin" ''
    export PATH="${
      lib.makeBinPath [
        pkgs.curl
        pkgs.jq
      ]
    }:$PATH"
    version="''${1:-$(${loadedVersion})}"
    [[ -n $version ]] || { echo "no version given and no nvidia kernel module loaded" >&2; exit 1; }

    base="https://download.nvidia.com/XFree86/Linux-x86_64/$version"
    file="NVIDIA-Linux-x86_64-$version.run"

    # nvidia publishes the checksum next to the installer, no need to download the ~400 MB
    echo "fetching the checksum of nvidia driver $version"
    hex=$(curl -sfL "$base/$file.sha256sum" | cut -d' ' -f1 || true)
    if [[ $hex =~ ^[0-9a-f]{64}$ ]]; then
      hash=$(nix hash convert --hash-algo sha256 --from base16 --to sri "$hex")
    else
      echo "no published checksum, downloading the whole driver to hash it"
      hash=$(nix store prefetch-file --json "$base/$file" | jq -r .hash)
    fi
    [[ $hash == sha256-* ]] || { echo "could not get the hash" >&2; exit 1; }

    sed -i -E \
      -e "s|(version = \")[0-9.]+(\";)|\1$version\2|" \
      -e "s|(sha256 = \")sha256-[^\"]*(\";)|\1$hash\2|" \
      "${pinFile}"

    echo "${pinFile}:"
    grep -nE '(version|sha256) = "[0-9sh]' "${pinFile}"
    echo "now run: home-manager switch (and the sudo .../non-nixos-gpu-setup it prints)"
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
      # Update both with `update-nvidia-pin`
      version = "595.99.02";
      sha256 = "sha256-6HR3lYv3YwcFSTJL1a1slI66btIQ5EAFs+/4SUD24ew=";
    };
  };

  home.packages = [
    checkNvidiaMatch
    updateNvidiaPin
  ];
  home.activation.checkNvidiaDriverMatch = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${lib.getExe checkNvidiaMatch} || true
  '';

  nix.assumeXdg = true;
}
