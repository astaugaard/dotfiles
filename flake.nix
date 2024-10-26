{
  description = "Home Manager configuration of a";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    nix-colors.url = "github:misterio77/nix-colors";

    niri = {
        url = "github:sodiboo/niri-flake";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-colors, catppuccin, nixpkgs-unstable, niri, ... }:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      myOverlays = [
              niri.overlays.niri
              (final: super: {
                rofi-wayland-unwrapped = super.rofi-wayland-unwrapped.overrideAttrs({ patches ? [], ... }: {
                patches = patches ++ [
                    (final.fetchpatch {
                        url = "https://github.com/samueldr/rofi/commit/55425f72ff913eb72f5ba5f5d422b905d87577d0.patch";
                        hash = "sha256-vTUxtJs4SuyPk0PgnGlDIe/GVm/w1qZirEhKdBp4bHI=";
                    })
                ];
                });
              })
              (import ./pkgs)];
      pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = myOverlays;
      };

      pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;
    in {
      homeConfigurations."a" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix catppuccin.homeManagerModules.catppuccin niri.homeModules.niri];


        extraSpecialArgs = {
            inherit pkgs-unstable;
            inherit nix-colors;
        };
      };

      nixosConfigurations = {
        nixos = lib.nixosSystem {
            inherit system;

            specialArgs = {
                inherit pkgs-unstable;
            };

            modules = [
                ({config, pkgs, ...}: { nixpkgs.overlays = myOverlays; }) # name a more hack way of doing this
                ./system/configuration.nix
                niri.outputs.nixosModules.niri
            ];
        };
      };
    };
}
