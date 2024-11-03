# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

# let mypkgs = import ./myPackages pkgs;
# in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = false;
    # 	version = 2;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
    theme = "${pkgs.grub-pets-min-theme}/grub/theme";
  };
  boot.loader.systemd-boot.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;
  hardware.opengl.package = pkgs.mesa.drivers;

  boot.plymouth = {
    enable = false;
    themePackages = [ pkgs.adi1090x-plymouth-themes ];
    theme = "hexagon_alt";
  };

  security.rtkit.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless = {
    environmentFile = /home/a/dotfiles/system/wifi-password;
    enable = true;
    networks."Whitemarsh".psk = "@WIFIPASS@";
    extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
  }; # Enables wireless support via wpa_supplicant.;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;
  # networking.wireless.iwd.enable = true;
  # networking.networkmanager.wifi.backend = "iwd";

  #  networking.wireless.enable = false

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # sound.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    package = pkgs-unstable.pipewire;
    systemWide = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # wireplumber.enable = true;
    # wireplumber.package = pkgs-unstable.wireplumber;
    # If you want to use JACK applications, uncomment this
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    # xkb.variant= "dvorak";
    enable = false;
    windowManager = {
      xmonad = {
        enable = false;
      };
    };

    displayManager.lightdm = {
      enable = false;
      greeters.mini = {
        enable = true;
        user = "a";
        extraConfig = ''
          			[greeter]
              		show-password-label = false
              		[greeter-theme]
                  		background-image = ""
                  	'';
      };
    };
  };

  services.seatd.enable = true;
  services.seatd.user = "a";

  services.displayManager.sddm.enable = false;
  services.displayManager.sddm.wayland.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  programs.regreet.enable = true;
  programs.regreet.settings = {
    background.fit = "Fill";
    background.path = ./wallhaven-6dq1w6.jpg;
    GTK.application_prefer_dark_theme = true;
    commands = {
      reboot = [
        "systemctl"
        "reboot"
      ];
      poweroff = [
        "systemctl"
        "poweroff"
      ];
    };
  };

  programs.sway.enable = true;
  programs.sway.package = pkgs.sway;

  programs.xwayland.enable = true;

  programs.niri.enable = true;
  # programs.niri.package = pkgs.niri-stable;
  niri-flake.cache.enable = false;

  security.polkit.enable = true;

  services.displayManager.defaultSession = "none+xmonad";

  services.flatpak.enable = true;

  services.ntp.enable = true;

  programs.gnupg.agent = {
    enable = true;

    pinentryPackage = pkgs.pinentry-curses;
  };

  programs.dconf.enable = true;

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    xorg.libX11
    xorg.libXcursor
    xorg.libxcb
    xorg.libXi
    libxkbcommon
  ];

  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;

  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  xdg.portal.enable = true;

  xdg.portal.wlr = {
    enable = true;
  };

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-wlr
  ];

  xdg.portal.config = {
    common = {
      default = [ "gtk" ];
    };
    # sway = {
    #   default = [
    #     "gtk"
    #     "wlr"
    #   ];
    # };
    niri = {
      default = [
        "gnome"
        "gtk"
        "wlr"
      ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.a = {
    isNormalUser = true;
    description = "astaugaard";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "wireshark"
      "pipewire"
      "video"
    ];
    packages = with pkgs; [ libglvnd ];
    initialPassword = "a";
  };

  # Allow unfree packages

  nixpkgs.config.allowUnfree = true;

  fonts = {
    packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "FiraCode" ];
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kakoune
    wget
    xterm
    fish
    postgresql
    libsecret
    catppuccin-gtk
    beauty-line-icon-theme
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  #  environment.variables = {
  #      WLR_RENDERER = "vulkan";
  #      GTK_USE_PORTAL = "0";
  #  };

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
    ];
    allowedUDPPorts = [ 17500 ];
  };

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  nix = {
    # package = pkgs.lix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };

  #  systemd.user.services.dropbox = {
  #	description = "Dropbox";
  #	after = [ "xembedsniproxy.service" ];
  #	wants = [ "xembedsniproxy.service" ];
  #	wantedBy = [ "graphical-session.target" ];
  ##	enviroment = {
  ##		QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
  ##	        QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
  ##	};
  #	serviceConfig = {
  #		ExecStart = "${pkgs.maestral.out}/bin/maestral start";
  #		ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
  #		KillMode = "control-group";
  #		PrivateTmp = true;
  #		ProtectSystem = "full";
  #		Nice = 10;
  #	};
  #  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
