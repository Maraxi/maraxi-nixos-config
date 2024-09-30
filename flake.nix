{
  description = "Stefan Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Only pull from 'nix-trunk' when channels are blocked by a Hydra jobset failure or
    # the 'unstable' channel has not otherwise updated recently for some other reason.
    # nix-trunk.url = "github:nixos/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    setup = {
      isNixOS = false;
    };
  in {
    overlays = import ./overlays {inherit inputs;};

    homeConfigurations."iv546" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./user/home.nix
      ];
      extraSpecialArgs = {
        inherit inputs outputs;
        setup = {
          username = "iv546";
          stateVersion = "24.05";
          isNixOS = false;
        };
      };
    };
    nixosConfigurations."stefan-nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit outputs;};
      modules = [
        ./hosts/nixos-laptop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.stefan = {
              imports = [
                ./hosts/nixos-laptop/home.nix
              ];
            };
            extraSpecialArgs = {
              setup = setup // {isNixOS = true;};
            };
          };
        }
      ];
    };
  };
}
