{ pkgs }:
pkgs.writeShellApplication {
  name = "lint";
  runtimeInputs = [
    pkgs.statix
    pkgs.deadnix
  ];
  text = ''
    rc=0
    statix check --config ${./statix.toml} || rc=1
    deadnix --fail . --exclude hosts/*/hardware-configuration.nix || rc=1
    exit "$rc"
  '';
}
