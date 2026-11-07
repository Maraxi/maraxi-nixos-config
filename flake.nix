{
  description = "Stefan Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Only pull from 'nix-trunk' when channels are blocked by a Hydra jobset failure or
    # the 'unstable' channel has not otherwise updated recently for some other reason.
    # nix-trunk.url = "github:nixos/nixpkgs";
    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixos-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      overlays = import ./overlays { inherit inputs; };
      pkgs = import nixpkgs { inherit system overlays; };
      keyboard = {
        layout = "de";
        variant = "nodeadkeys";
        # man xkeyboard-config  -> Options
        # nix run nixpkgs#libxkbcommon list | less
        options = [
          "caps:escape"
          "shift:both_capslock_cancel"
          "compose:rctrl"
        ];
      };

      de = "de_DE.UTF-8";
      locale = {
        LC_ADDRESS = de;
        LC_COLLATE = de;
        LC_CTYPE = de;
        LC_IDENTIFICATION = de;
        LC_MEASUREMENT = de;
        LC_MESSAGES = "en_GB.UTF-8";
        LC_MONETARY = de;
        LC_NAME = de;
        LC_NUMERIC = de;
        LC_PAPER = de;
        LC_TELEPHONE = de;
        LC_TIME = de;
      };
    in
    {
      # Run as `nix fmt`
      formatter.${system} = import ./tools/formatter.nix { inherit pkgs; };

      # Run as `nix run .#lint`
      apps.${system}.lint = {
        type = "app";
        program = nixpkgs.lib.getExe (import ./tools/lint.nix { inherit pkgs; });
        meta.description = "Run statix and deadnix over the flake";
      };

      nixosConfigurations = {
        stefan-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit keyboard locale;
            hostName = "stefan-nixos";
          };
          modules = [
            ./hosts/nixos
            ./system
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = overlays;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.stefan.imports = [ ./user ];
                extraSpecialArgs = {
                  inherit inputs keyboard;
                  # inherit pkgs-stable;
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
      };
      homeConfigurations = {
        "iv546_local@pc9d217" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./user ];
          extraSpecialArgs = {
            inherit inputs keyboard locale;
            setup = {
              username = "iv546_local";
              stateVersion = "24.05";
              isNixOS = false;
            };
          };
        };
      };

      devShells.${system} =
        let
          red = ''\e[0;31m'';
          reset = ''\e[0m'';
        in
        {
          appimage = pkgs.mkShell { packages = [ pkgs.appimage-run ]; };
          latex = pkgs.mkShell {
            packages = with pkgs; [
              texlive.combined.scheme-full
              texstudio
            ];
          };
          zig = pkgs.mkShell {
            packages = [ pkgs.zig ];
            shellHook = ''echo -e ">> ${red}zig version: ${pkgs.zig.version}${reset}"'';
          };
          protobuf = pkgs.mkShell {
            packages = [ pkgs.protobuf ];
            shellHook = ''echo -e ">> ${red}protoc: ${pkgs.protobuf.version}${reset}"'';
          };
          python-jupyter = pkgs.mkShell {
            packages = with pkgs.python3Packages; [
              jupyterlab
              matplotlib
            ];
            shellHook = ''
              echo -e \
              ">> ${red}jupyter-lab version: ${pkgs.python3Packages.jupyterlab.version}${reset}
              >> start the server with:
              >> ${red}jupyter-lab${reset}"
            '';
          };
        };
    };
}
