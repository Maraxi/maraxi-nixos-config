{
  # https://github.com/nix-community/home-manager/blob/master/docs/manual/usage/gpu-non-nixos.md
  targets.genericLinux = {
    enable = true;
    gpu.nvidia = {
      enable = false;
      # Check version in
      # nvidia-smi -q | grep "Driver Version"
      version = "595.71.05";
      sha256 = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
    };
  };
}
