{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  # additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  # modifications = final: prev: {
  # example = prev.example.overrideAttrs (oldAttrs: rec {
  # ...
  # });
  # };

  # When applied, the latest nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.trunk'
  trunk-packages = final: _prev: {
    trunk = import inputs.nix-trunk {
      system = final.system;
    };
  };
}
