{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  ...
}:
with builtins;
with lib;
{
  options.mysystem = {
    sway = mkOption {
      description = "enable sway system stuff";
      type = lib.types.bool;
      default = false;
    };
    niri = mkOption {
      description = "enable niri system stuff";
      type = lib.types.bool;
      default = false;
    };
    xmonad = mkOption {
      description = "enable xmonad system stuff";
      type = lib.types.bool;
      default = false;
    };
    xserver = mkOption {
      description = "enable x11 system stuff";
      type = lib.types.bool;
      default = config.mysystem.xmonad;
    };
    gui = mkOption {
      description = "enable common gui components";
      type = lib.types.bool;
      default = config.mysystem.niri || config.mysystem.sway || config.mysystem.xmonad;
    };
    loginManager = mkOption {
      description = "enable login manager";
      type = lib.types.bool;
      default = config.mysystem.gui;
    };
  };

  config = mkIf config.mysystem.gui {
    environment.systemPackages = with pkgs; [
      catppuccin-gtk
      beauty-line-icon-theme
      xterm
    ];

    programs.sway.enable = config.mysystem.sway;
    programs.sway.package = pkgs.sway;

    programs.niri.enable = config.mysystem.niri;
    niri-flake.cache.enable = false;

    programs.xwayland.enable = true;

    fonts = {
      packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
      fontconfig = {
        defaultFonts = {
          monospace = [ "FiraCode" ];
        };
      };
    };

    services.xserver = {
      xkb.layout = "us";
      # xkb.variant= "dvorak";
      enable = config.mysystem.xserver;
      windowManager = {
        xmonad = {
          enable = config.mysystem.xmonad;
        };
      };
    };

    services.seatd.enable = config.mysystem.loginManager;

    services.greetd = {
      enable = config.mysystem.loginManager;
      settings = {
        default_session = {
          # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet";
          user = "greeter";
        };
      };
    };

    programs.regreet.enable = config.mysystem.loginManager;
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

    services.pipewire = {
      enable = true;
      audio.enable = true;
      package = pkgs-unstable.pipewire;
      systemWide = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    hardware.opengl.driSupport = true;
    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.enable = true;
    hardware.opengl.package = pkgs.mesa.drivers;
  };
}
