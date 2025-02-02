{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
{
  imports = [
    ./flatpak.nix
    ./gui.nix
    ./amd.nix
    ./tailscale.nix
    ./ssh.nix
    ./k3s.nix
    ./freshrss.nix
  ];

  options.mysystem = {
    enablegc = mkOption {
      description = "enable garbage collection of nix store";
      type = lib.types.bool;
      default = false;
    };
    firewall = mkOption {
      description = "enable firewall";
      type = lib.types.bool;
      default = false;
    };
    user = mkOption {
      description = "main user for the system";
      type = lib.types.str;
    };
    userdescription = mkOption {
      description = "full name of the user";
      type = lib.types.str;
    };
    wpasupplicant = {
      enable = mkOption {
        description = "enable wpa_supplicant";
        type = lib.types.bool;
        default = false;
      };
      envfile = mkOption {
        description = "filepath to wifi password env file";
        type = lib.types.path;
        default = "/home/${config.mysystem.user}/dotfiles/wifi-password";
      };
    };

    initialPassword = mkOption {
      description = "initial password for the user";
      type = lib.types.nullOr lib.types.str;
      default = "a";
    };

    systemd-boot = mkOption {
      description = "enable systemd boot";
      type = lib.types.bool;
      default = true;
    };

    grub = mkOption {
      description = "enable grub";
      type = lib.types.bool;
      default = false;
    };

    grub-device = mkOption {
      description = "device to install grub on";
      type = lib.types.str;
      default = "nodev";
    };

    virt = mkOption {
      description = "virtualization support";
      type = lib.types.bool;
      default = false;
    };

    aarch-binfmt = mkOption {
      description = "enable binfmt emulation of aarch64-linux";
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    virtualisation.libvirtd.enable = config.mysystem.virt;

    boot.binfmt.emulatedSystems = if config.mysystem.aarch-binfmt then [ "aarch64-linux" ] else [ ];

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub = {
      enable = config.mysystem.grub;
      # 	version = 2;
      device = config.mysystem.grub-device;
      # useOSProber = true;
      efiSupport = if config.mysystem.grub-device == "nodev" then true else false;
      theme = "${pkgs.grub-pets-min-theme}/grub/theme";
    };
    boot.loader.systemd-boot.enable = config.mysystem.systemd-boot;

    environment.systemPackages = with pkgs; [
      kakoune
      wget
      fish
      libsecret
    ];

    users.users."${(config.mysystem.user)}" = {
      isNormalUser = true;
      description = config.mysystem.userdescription;
      extraGroups = [
        # just set by default bc I don't care
        "networkmanager"
        "wheel"
        "audio"
        "wireshark"
        "pipewire"
        "video"
        "libvirtd"
      ];
      packages = with pkgs; [ libglvnd ];
      initialPassword = config.mysystem.initialPassword;
    };

    users.defaultUserShell = pkgs.fish;
    programs.fish.enable = true;

    nixpkgs.config.allowUnfree = true;
    nix = {
      # package = pkgs.lix;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      gc = {
        automatic = config.mysystem.enablegc;
        dates = "weekly";
        options = "--delete-older-than 5d";
      };

      settings.trusted-users = [ "${config.mysystem.user}" ];
    };

    networking.firewall.enable = config.mysystem.firewall;

    networking.firewall = {
      allowedTCPPorts = [
        17500
        22
      ];
      allowedUDPPorts = [
        17500
        22
      ];
    };

    security.polkit.enable = true;
    services.ntp.enable = true;

    sops.defaultSopsFile = ../secrets/wifi.json;
    sops.defaultSopsFormat = "json";
    sops.age.keyFile = "/home/${config.mysystem.user}/.config/sops/age/keys.txt";
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    sops.age.generateKey = true;

    sops.secrets.password = { };
    sops.templates."wifi.env".content = ''
      password=${config.sops.placeholder.password}
    '';

    networking.wireless = {
      secretsFile = config.sops.templates."wifi.env".path;
      enable = config.mysystem.wpasupplicant.enable;
      networks."Whitemarsh".pskRaw = "ext:password";
      extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
    };

    system.stateVersion = "22.05";
  };
}
