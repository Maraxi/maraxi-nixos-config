{
  config,
  lib,
  pkgs,
  ...
}:
let
  # dix defaults to the NixOS system profile, which does not exist here. `dix last` should look at the
  # home-manager generations instead.
  dix = pkgs.writeShellScriptBin "dix" ''
    if [ "''${1:-}" = last ]; then
      shift
      set -- last --profile ${lib.escapeShellArg "${config.xdg.stateHome}/nix/profiles/home-manager"} "$@"
    fi
    exec ${lib.getExe pkgs.dix} "$@"
  '';
in
{
  home.packages = [ dix ];
}
