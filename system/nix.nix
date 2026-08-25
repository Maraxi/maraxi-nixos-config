{ pkgs, ... }: {
  nix = {
    package = pkgs.nixVersions.stable;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      use-xdg-base-directories = true;
      # warn-dirty = false;
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
