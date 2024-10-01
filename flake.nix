{
  description = "Home Manager configuration of a";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    nix-colors.url = "github:misterio77/nix-colors";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-colors, catppuccin, nixpkgs-unstable, ... }:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
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
        modules = [ ./home.nix catppuccin.homeManagerModules.catppuccin ];


        extraSpecialArgs = {
            inherit pkgs-unstable;
            inherit nix-colors;
        };
      };

      nixosConfigurations = {
        nixos = lib.nixosSystem {
            inherit system;

            modules = [
                ./system/configuration.nix
            ];
        };
      };
    };
}
