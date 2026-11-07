{ inputs }:
[
  # waybar 0.16 is in nixpkgs master but not yet in nixos-unstable. Take it from nix-trunk until unstable
  # has it (version-gated, so this retires itself).
  (
    final: prev:
    let
      trunk = inputs.nixos-unstable-small.legacyPackages.${final.stdenv.hostPlatform.system};
    in
    {
      waybar = if prev.lib.versionOlder prev.waybar.version "0.16.0" then trunk.waybar else prev.waybar;
    }
  )

  (import ./upstream-fixes.nix)
]
