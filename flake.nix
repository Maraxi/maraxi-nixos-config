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
    kickstart-nix-nvim = {
      url = "github:Maraxi/kickstart-nix.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    kickstart-nix-nvim,
    nixgl,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations."stefan-nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit outputs kickstart-nix-nvim;
      };
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
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./user/home.nix
        ./user/ecc.nix
      ];
      extraSpecialArgs = {
        inherit inputs outputs kickstart-nix-nvim nixgl;
        setup = {
          username = "iv546";
          stateVersion = "24.05";
          isNixOS = false;
        };
      };
    };
  };
}
