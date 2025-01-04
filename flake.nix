{
  description = "Home Manager configuration of a";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
      nixpkgs-unstable,
      niri,
      nixos-generators,
      ...
    }:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      myOverlays = [
        niri.overlays.niri
        (import ./pkgs)
      ];
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = myOverlays;
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      lib = nixpkgs.lib;
    in
    {
      homeConfigurations."a" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          niri.homeModules.niri
          stylix.homeManagerModules.stylix
          # {
          #   imports = [ stylix.homeManagerModules.stylix ];
          #   disabledModules = [
          #     "${stylix}/modules/kubecolor/hm.nix"
          #     "${stylix}/modules/ghostty/hm.nix"
          #   ];
          # }
        ];

        extraSpecialArgs = {
          inherit pkgs-unstable;
          # inherit nix-colors;
        };
      };

      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit pkgs-unstable;
          };

          modules = [
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = myOverlays;
              }
            ) # name a more hack way of doing this
            ./configuration.nix
            ./systemModules
            niri.outputs.nixosModules.niri
          ];
        };

      };

      homeModules.myhome =
        { config }:
        {
          imports = [
            (import ./modules { standalone = true; })
            niri.homeModules.niri
            stylix.homeManagerModules.stylix
          ];
          options = { };
          config = { };
        };

      nixosModules.mysystem =
        { config }:
        {
          imports = [
            ./systemModules
            niri.outputs.nixosModules.niri
          ];
          options = { };
          config = { };
        };

      packages.x86_64-linux.iso = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "install-iso";
        specialArgs = {
          inherit pkgs-unstable;
        };
        modules = [
          (
            {
              config,
              pkgs,
              modulesPath,
              ...
            }:
            {
              imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-base.nix") ];
              nixpkgs.overlays = myOverlays;
              security.polkit.extraConfig = ''
                polkit.addRule(function(action, subject) {
                  if (subject.isInGroup("wheel")) {
                    return polkit.Result.YES;
                  }
                });
              '';

              networking.networkmanager.enable = true;
              networking.wireless.enable = lib.mkImageMediaOverride false;
              services.spice-vdagentd.enable = true;
              services.qemuGuest.enable = true;
              virtualisation.vmware.guest.enable = pkgs.stdenv.hostPlatform.isx86;
              virtualisation.hypervGuest.enable = true;
              services.xe-guest-utilities.enable = pkgs.stdenv.hostPlatform.isx86;
              # The VirtualBox guest additions rely on an out-of-tree kernel module
              # which lags behind kernel releases, potentially causing broken builds.
              virtualisation.virtualbox.guest.enable = false;
              boot.plymouth.enable = true;

              environment.defaultPackages = with pkgs; [
                # Include gparted for partitioning disks.
                gparted

                # Include some editors.
                vim
                nano

                # Include some version control tools.
                git
                rsync

                # Firefox for reading the manual.
                firefox

                mesa-demos
              ];

              services.displayManager = {
                sddm.enable = true;
                sddm.wayland.enable = true;
                autoLogin = {
                  enable = true;
                  user = "nixos";
                };
              };

              mysystem.niri = true;

              mysystem.user = "nixos";
              mysystem.userdescription = "nixos";
              mysystem.initialPassword = null;
              mysystem.loginManager = false;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."nixos" =
                {
                  config,
                  pkgs,
                  lib,
                  ...
                }:
                {
                  imports = [
                    # niri.homeModules.niri
                    stylix.homeManagerModules.stylix
                    (import ./modules { standalone = false; })
                  ];

                  programs.niri.settings = (
                    import ./modules/niri/settings.nix {
                      inherit lib;
                      inherit pkgs;
                      inherit config;
                    }
                  );

                  myhome.xmonad.enable = false;
                  myhome.sway.enable = false;
                  myhome.deway.enable = true;
                  myhome.decommon.enable = true;
                  # myhome.niri.enable = false;
                  # myhome.niri.overloadNiriPackage = false;
                  myhome.toys.enable = false;
                  myhome.devtools.enable = false;
                  myhome.kak.enable = true;
                  myhome.flatpak.enable = false;
                  myhome.dropbox.enable = false;
                  myhome.desktop.enable = false;
                  myhome.username = "nixos";
                };
            }
          ) # name a more hack way of doing this
          ./systemModules
          home-manager.nixosModules.home-manager
          niri.outputs.nixosModules.niri
        ];
      };
    };
}
