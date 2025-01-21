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

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules = {
      # not used because idk if I can make it follow stable
      url = "github:numtide/nixos-facter-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:/nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      nixpkgs-unstable,
      niri,
      nixos-generators,
      nix-flatpak,
      sops-nix,
      disko,
      deploy-rs,
      nixos-facter-modules,
      nixos-hardware,
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
            inherit pkgs-unstable-arm;
          };

          modules = [
            (
              { config, pkgs, ... }:
              {
                # imports = [ ./rpi-disko-config.nix ];

                nixpkgs.overlays = myOverlays;
                sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

                i18n.defaultLocale = "en_US.utf8";
                networking.hostName = "rpi-home";
                time.timeZone = "America/New_York";
                mysystem.user = "nixos";
                mysystem.userdescription = "admin";

                boot.kernel.sysctl = {
                  "vm.swappiness" = 60;
                };

                swapDevices = [
                  {
                    device = "/var/lib/swapfile";
                    size = 16 * 1024;
                  }
                ];

                mysystem.enablegc = true;
                mysystem.wpasupplicant.enable = true;
                mysystem.tailscale.enable = true;
                mysystem.tailscale.authkey = "tailscale-server-auth";
                mysystem.ssh.enable = true;
                mysystem.k3s.enable = true;
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

        # installer-sd = lib.nixosSystem {
        #   system = "aarch64-linux";

        #   specialArgs = {
        #     inherit pkgs-unstable;
        #   };

        #   modules = [
        #     (
        #       { config, pkgs, ... }:
        #       {

        #         # imports = [ ./rpi-disko-config.nix ];

        #         nixpkgs.overlays = myOverlays;

        #         i18n.defaultLocale = "en_US.utf8";
        #         networking.hostName = "installer-sd";
        #         time.timeZone = "America/New_York";
        #         mysystem.user = "a";
        #         mysystem.userdescription = "admin";

        #         mysystem.enablegc = true;
        #         mysystem.wpasupplicant.enable = true;
        #         mysystem.tailscale.enable = true;
        #         mysystem.tailscale.authkey = "tailscale-temp-auth";
        #         mysystem.ssh.enable = true;
        #         mysystem.ssh.root-login = true;

        #         mysystem.flatpak.enable = false;
        #         mysystem.niri = false;
        #         mysystem.sway = false;
        #         mysystem.xmonad = false;
        #         mysystem.amd = false;
        #         mysystem.virt = false;
        #         mysystem.k3s.enable = false;
        #         mysystem.systemd-boot = false;
        #       }
        #     )
        #     ./systemModules
        #     niri.outputs.nixosModules.niri # not used at all in config lol
        #     # ./rpi-home-hardware-configuration.nix
        #     # nixos-facter-modules.nixosModules.facter
        #     # { config.facter.reportPath = ./facter.json; }
        #     sops-nix.nixosModules.sops
        #     # disko.nixosModules.disko
        #   ];
        # };
      };

      deploy.nodes.rpi-home = {
        hostname = "rpi-home";
        profiles.system = {
          user = "root";
          sshUser = "nixos";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.rpi-home;
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
                    nix-flatpak.homeManagerModules.nix-flatpak
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
          sops-nix.nixosModules.sops
          niri.outputs.nixosModules.niri
        ];
      };
    };
}
