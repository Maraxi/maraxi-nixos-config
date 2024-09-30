{
  description = "Stefan Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    setup = {
      isNixOS = false;
    };
  in {
    homeConfigurations."iv546" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./hosts/iv546-thinkpad/home.nix
      ];
      extraSpecialArgs = {
        inherit inputs;
        setup = setup;
      };
    };
    nixosConfigurations."stefan-nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
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
