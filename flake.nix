{
  description = "Home Manager configuration of a";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      flake = false;
    };

    quick-launch = {
      url = "github:astaugaard/quick-launch/main";
      flake = false;
    };

    gtk-confirmation-dialog = {
      url = "github:astaugaard/gtk-confirmation-dialog/main";
      flake = false;
    };

    prideful = {
      url = "github:angelofallars/prideful/main";
      flake = false;
    };

    reasymotion = {
      url = "github:astaugaard/reasymotion/main";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      stylix,
      nixpkgs-unstable,
      niri,
      nix-flatpak,
      sops-nix,
      # nixos-facter-modules,
      nixos-hardware,
      ...
    }:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      myOverlays = [
        niri.overlays.niri
        (import ./pkgs inputs)
      ];

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = myOverlays;
      };

      pkgs-arm = import nixpkgs {
        system = "aarch64-linux";
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

      pkgs-unstable-arm = import nixpkgs-unstable {
        system = "aarch64-linux";
        config = {
          allowUnfree = true;
        };
      };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

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
          stylix.homeModules.stylix
          nix-flatpak.homeManagerModules.nix-flatpak
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
            sops-nix.nixosModules.sops
          ];
        };

        rpi-home = lib.nixosSystem {
          system = "aarch64-linux";

          specialArgs = {
            pkgs-unstable = pkgs-unstable-arm;
          };

          modules = [
            (
              { config, pkgs, ... }:
              {
                # imports = [ ./rpi-disko-config.nix ];

                nixpkgs.overlays = myOverlays;
                sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

                i18n.defaultLocale = "en_US.UTF-8";
                networking.hostName = "rpi-home";
                time.timeZone = "America/New_York";
                mysystem.user = "nixos";
                mysystem.userdescription = "admin";

                boot.kernel.sysctl = {
                  "vm.swappiness" = 60;
                };

                boot.kernelParams = [
                  "cgroup_memory=1"
                  "cgroup_enable=memory"
                ];

                # networking = {
                #   interfaces.end0 = {
                #     addresses = [
                #       {
                #         address = "169.254.90.188";
                #         prefixLength = 24;
                #       }
                #     ];
                #   };
                # };

                swapDevices = [
                  {
                    device = "/var/lib/swapfile";
                    size = 16 * 1024;
                  }
                ];

                mysystem.enablegc = true;
                mysystem.wpasupplicant.enable = true;
                mysystem.ssh.enable = true;
                mysystem.wireguard-host.enable = true;
                mysystem.invidious.enable = true;
                mysystem.pixelfed.enable = false;

                mysystem.freshrss.enable = true;

                mysystem.systemd-boot = false;
                mysystem.grub = false;
                mysystem.grub-device = "/dev/mmcblk0";

                mysystem.flatpak.enable = false;
                mysystem.niri = false;
                mysystem.sway = false;
                mysystem.xmonad = false;
                mysystem.amd = false;
                mysystem.virt = false;
              }
            )
            ./systemModules
            niri.outputs.nixosModules.niri # not used at all in config lol
            ./rpi-home-hardware-configuration.nix
            # nixos-facter-modules.nixosModules.facter
            # { config.facter.reportPath = ./rpi-facter.json; }
            sops-nix.nixosModules.sops
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };
      };

      formatter = forAllSystems (system: inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      homeModules.astaugaard-home =
        { config }:
        {
          imports = [
            (import ./modules { standalone = true; })
            niri.homeModules.niri
            stylix.homeModules.stylix
          ];
          options = { };
          config = { };
        };

      nixosModules.astaugaard-system =
        { config }:
        {
          imports = [
            ./systemModules
            niri.outputs.nixosModules.niri
          ];
          options = { };
          config = { };
        };
    };
}
