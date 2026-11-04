_final: prev: {
  # opencode 2.2.5's node_modules hash is wrong in nixos-unstable
  # (NixOS/nixpkgs#582673); the value is the one nixpkgs#582675 sets.
  # Version-gated so it retires itself once unstable moves past 2.2.5.
  opencode =
    if prev.opencode.version == "2.2.5" then
      prev.opencode.overrideAttrs (old: {
        node_modules = old.node_modules.overrideAttrs {
          outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
        };
      })
    else
      prev.opencode;
}
