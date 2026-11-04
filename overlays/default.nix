{ inputs }:
[
  # Comes from the waybar flake input, not nixpkgs.
  # Upstream's flaky sleeper_thread subprocess test has failed in the NixOS build sandbox, so skip the
  # checks. Drop once upstream fixed the test.
  (final: _prev: {
    waybar = inputs.waybar.packages.${final.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      doCheck = false;
      mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dtests=disabled" ];
    });
  })

  (import ./upstream-fixes.nix)
]
