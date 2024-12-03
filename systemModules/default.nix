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

    virt = mkOption {
      description = "virtualization support";
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    virtualisation.libvirtd.enable = config.mysystem.virt;

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub = {
      enable = false;
      # 	version = 2;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      theme = "${pkgs.grub-pets-min-theme}/grub/theme";
    };
    boot.loader.systemd-boot.enable = true;

    security.rtkit.enable = true;

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
    };

    networking.firewall.enable = config.mysystem.firewall;

    networking.firewall = {
      allowedTCPPorts = [
        17500
        17599
        17600
        17601
        17602
        17603
        17604
        17605
        17606
        17607
        17608
        17609
        53317 # for localsend
      ];
      allowedUDPPorts = [
        17500
        53317
      ];
    };

    security.polkit.enable = true;
    services.ntp.enable = true;
    programs.dconf.enable = true;

    networking.wireless = {
      secretsFile = config.mysystem.wpasupplicant.envfile;
      enable = config.mysystem.wpasupplicant.enable;
      networks."Whitemarsh".pskRaw = "ext:psk_home";
      extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
    };

    system.stateVersion = "22.05"; # Did you read the comment?
  };
}
