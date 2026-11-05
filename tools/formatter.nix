{ pkgs }:
pkgs.writeShellApplication {
  name = "treefmt";
  runtimeInputs = [
    pkgs.treefmt
    pkgs.nixfmt
  ];
  text = ''treefmt --config-file ${./treefmt.toml} --tree-root-cmd "git rev-parse --show-toplevel" "$@"'';
}
