{
  description = "Stefan Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Only pull from 'nix-trunk' when channels are blocked by a Hydra jobset failure or
    # the 'unstable' channel has not otherwise updated recently for some other reason.
    # nix-trunk.url = "github:nixos/nixpkgs";

    # Downgrade for broken pkgs.pamixer build
    nixpkgs-73cf49.url = "github:NixOS/nixpkgs/73cf49b8ad837ade2de76f87eb53fc85ed5d4680";

    # Downgrade for bad feature in chromium
    nixpkgs-be02d8.url = "github:NixOS/nixpkgs/be02d861eace1ba8d9cac31d0493af1032ca4b2f";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-73cf49,
    nixpkgs-be02d8,
    home-manager,
    nixgl,
    ...
  }: let
    # inherit (self) outputs;
    system = "x86_64-linux";
  in {
    # overlays = import ./overlays {inherit inputs;};

    nixosConfigurations."stefan-nixos" = nixpkgs.lib.nixosSystem {
      inherit system;
      # specialArgs = { };
      modules = [
        ./hosts/nixos-laptop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.stefan = {
              imports = [
                ./user/home.nix
              ];
            };
            extraSpecialArgs = {
              pkgs-73cf49 = import nixpkgs-73cf49 {inherit system;};
              setup = {
                username = "stefan";
                stateVersion = "24.05";
                isNixOS = true;
              };
            };
          };
        }
      ];
    };
    homeConfigurations."iv546@pc9d217" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {inherit system;};
      modules = [
        ./user/home.nix
        ./user/ecc.nix
        ./user/nixpkgs.nix
      ];
      extraSpecialArgs = {
        inherit nixgl;
        pkgs-be02d8 = import nixpkgs-be02d8 {inherit system;};
        setup = {
          username = "iv546";
          stateVersion = "24.05";
          isNixOS = false;
        };
      };
    };
  };
}
