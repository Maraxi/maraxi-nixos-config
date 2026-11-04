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

  # v0.2.1 (nixpkgs) cannot parse the monitor json of Hyprland >= 0.56 (outputs/windows tabs empty, only
  # region works). Fixed in v0.3.1. Version-gated so it retires itself once nixpkgs has it.
  hyprland-preview-share-picker =
    if prev.lib.versionOlder prev.hyprland-preview-share-picker.version "0.3.1" then
      prev.hyprland-preview-share-picker.overrideAttrs (old: rec {
        version = "0.3.1";
        src = prev.fetchFromGitHub {
          owner = "WhySoBad";
          repo = "hyprland-preview-share-picker";
          tag = "v${version}";
          hash = "sha256-Rhwy+W3vrnlhoLbRG9AIOQYt7Ar9APXKvgS9NJFHDbk=";
        };
        cargoDeps = prev.rustPlatform.importCargoLock { lockFile = "${src}/Cargo.lock"; };
        # git submodule lib/hyprland-protocols is not part of the github tarball
        postPatch = (old.postPatch or "") + ''
          mkdir -p lib/hyprland-protocols
          cp -r ${prev.hyprland-protocols}/share/hyprland-protocols/protocols lib/hyprland-protocols/
        '';
      })
    else
      prev.hyprland-preview-share-picker;
}
