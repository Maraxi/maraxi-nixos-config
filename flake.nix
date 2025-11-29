{
  description = "Stefan Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Only pull from 'nix-trunk' when channels are blocked by a Hydra jobset failure or
    # the 'unstable' channel has not otherwise updated recently for some other reason.
    # nix-trunk.url = "github:nixos/nixpkgs";

    # Downgrade for bad feature in chromium
    # nixpkgs-be02d8.url = "github:NixOS/nixpkgs/be02d861eace1ba8d9cac31d0493af1032ca4b2f";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    # nixpkgs-be02d8,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    keyboard = {
      layout = "de";
      variant = "nodeadkeys";
      # man xkeyboard-config  -> Options
      options = "caps:escape,shift:both_capslock_cancel,compose:rctrl";
    };
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];
  in {
    nixosConfigurations = {
      stefan-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit keyboard;
          hostName = "stefan-nixos";
        };
        modules = [
          {nixpkgs.overlays = overlays;}
          ./hosts/nixos
          ./system/android.nix
          ./system/boot-drives.nix
          ./system/environment.nix
          ./system/fonts.nix
          ./system/greetd.nix
          ./system/hyprland.nix
          ./system/locale.nix
          ./system/misc.nix
          ./system/networking-ssh.nix
          ./system/nix.nix
          ./system/nvidia.nix
          ./system/print-scan.nix
          ./system/shokz.nix
          ./system/sound.nix
          ./system/steam.nix
          ./system/users.nix
          ./system/voyager.nix
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
                inherit inputs;
                inherit keyboard;
                setup = {
                  username = "stefan";
                  stateVersion = "24.11";
                  isNixOS = true;
                  installChromium = false;
                };
              };
            };
          }
        ];
      };
      raspberrypi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/pi
        ];
      };
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
          inherit inputs;
          inherit keyboard;
          # pkgs-be02d8 = import nixpkgs-be02d8 {inherit system;};
          setup = {
            username = "iv546";
            stateVersion = "24.05";
            isNixOS = false;
            installChromium = true;
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
          inherit inputs;
          inherit keyboard;
          setup = {
            username = "stefan";
            stateVersion = "24.05";
            isNixOS = false;
            installChromium = false;
          };
        };
      };
    };
    devShells.${system} = let
      red = ''\e[0;31m'';
      reset = ''\e[0m'';
    in {
      appimage = pkgs.mkShell {
        packages = [pkgs.appimage-run];
      };
      latex = pkgs.mkShell {
        packages = with pkgs; [
          texlive.combined.scheme-full
          texstudio
        ];
      };
      zig = pkgs.mkShell {
        packages = [pkgs.zig];
        shellHook = ''echo "${red}zig${reset} version: $(zig version)"'';
      };
      protobuf = pkgs.mkShell {
        packages = [pkgs.protobuf];
        shellHook = ''protoc  --version'';
      };
      python-jupyter = pkgs.mkShell {
        packages = with pkgs.python313Packages; [
          jupyterlab
          matplotlib
        ];
        shellHook = ''echo -e "${red}jupyter-lab${reset} version: $(jupyter-lab --version)"'';
      };
    };
  };
}
