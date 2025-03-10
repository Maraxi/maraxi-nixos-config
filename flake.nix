{
  description = "Stefan Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Only pull from 'nix-trunk' when channels are blocked by a Hydra jobset failure or
    # the 'unstable' channel has not otherwise updated recently for some other reason.
    # nix-trunk.url = "github:nixos/nixpkgs";

    # Downgrade for bad feature in chromium
    nixpkgs-be02d8.url = "github:NixOS/nixpkgs/be02d861eace1ba8d9cac31d0493af1032ca4b2f";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-be02d8,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    keyboard = {
      layout = "de";
      variant = "nodeadkeys";
      # man xkeyboard-config  -> Options
      options = "caps:escape, shift:both_capslock, compose:rctrl";
    };
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
              inherit keyboard;
              setup = {
                username = "stefan";
                stateVersion = "24.05";
                isNixOS = true;
                installFirefox = true;
              };
            };
          };
        }
      ];
    };
    homeConfigurations = {
      "iv546@pc9d217" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./user/home.nix
          ./user/ecc.nix
          ./user/nixpkgs.nix
        ];
        extraSpecialArgs = {
          inherit keyboard;
          pkgs-be02d8 = import nixpkgs-be02d8 {inherit system;};
          setup = {
            username = "iv546";
            stateVersion = "24.05";
            isNixOS = false;
            installFirefox = false;
          };
        };
      };
      "stefan@pc9d217" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./user/home.nix
          ./user/nixpkgs.nix
        ];
        extraSpecialArgs = {
          inherit keyboard;
          setup = {
            username = "stefan";
            stateVersion = "24.05";
            isNixOS = false;
            installFirefox = true;
          };
        };
      };
    };
    devShells.${system} = {
      latex = pkgs.mkShell {
        packages = with pkgs; [
          texlive.combined.scheme-full
          texstudio
        ];
      };
      zig = pkgs.mkShell {
        packages = [pkgs.zig];
        shellHook = ''echo "zig version: $(zig version)"'';
      };
      protobuf = pkgs.mkShell {
        packages = [pkgs.protobuf];
        shellHook = ''protoc  --version'';
      };
    };
  };
}
