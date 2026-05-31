{
  description = "Stefan Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixstable.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Only pull from 'nix-trunk' when channels are blocked by a Hydra jobset failure or
    # the 'unstable' channel has not otherwise updated recently for some other reason.
    # nix-trunk.url = "github:nixos/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nixstable,
    home-manager,
    nixos-hardware,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    keyboard = {
      layout = "de";
      variant = "nodeadkeys";
      # man xkeyboard-config  -> Options
      options = "caps:escape,compose:rctrl";
    };
  in {
    # overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      stefan-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit keyboard;
          hostName = "stefan-nixos";
        };
        modules = [
          ./hosts/nixos
          ./system
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.stefan = {imports = [./user];};
              extraSpecialArgs = {
                inherit inputs;
                inherit keyboard;
                setup = {
                  username = "stefan";
                  stateVersion = "24.11";
                  isNixOS = true;
                };
              };
            };
          }
        ];
      };
      raspberrypi = nixstable.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/pi
        ];
      };
    };
    homeConfigurations = {
      "iv546@pc9d217" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./user ./user/ecc.nix];
        extraSpecialArgs = {
          inherit inputs;
          inherit keyboard;
          setup = {
            username = "iv546";
            stateVersion = "24.05";
            isNixOS = false;
          };
        };
      };
      "stefan@pc9d217" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./user];
        extraSpecialArgs = {
          inherit inputs;
          inherit keyboard;
          setup = {
            username = "stefan";
            stateVersion = "24.05";
            isNixOS = false;
          };
        };
      };
    };

    devShells.${system} = let
      red = ''\e[0;31m'';
      reset = ''\e[0m'';
    in {
      appimage = pkgs.mkShell {packages = [pkgs.appimage-run];};
      latex = pkgs.mkShell {
        packages = with pkgs; [texlive.combined.scheme-full texstudio];
      };
      zig = pkgs.mkShell {
        packages = [pkgs.zig];
        shellHook = ''echo -e ">> ${red}zig version: $(zig version)${reset}"'';
      };
      protobuf = pkgs.mkShell {
        packages = [pkgs.protobuf];
        shellHook = ''echo -e ">> ${red}protoc: $(protoc  --version)${reset}"'';
      };
      python-jupyter = pkgs.mkShell {
        packages = with pkgs.python314Packages; [jupyterlab matplotlib];
        shellHook = ''
          echo -e \
          ">> ${red}jupyter-lab version: $(jupyter-lab --version)${reset}
          >> start the server with:
          >> ${red}jupyter-lab${reset}"
        '';
      };
    };
  };
}
