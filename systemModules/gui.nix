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

    boot = {
      plymouth = {
        enable = true;
        theme = "rings_2";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "rings_2" ];
          })
        ];
      };

      kernelParams = [
        "splash"
        "boot.shell_on_fail"
      ];
    };

    programs.dconf.enable = true;
    security.rtkit.enable = true;

    programs.sway.enable = config.mysystem.sway;
    programs.sway.package = pkgs.sway;

    programs.niri.enable = config.mysystem.niri;
    niri-flake.cache.enable = false;

    programs.xwayland.enable = true;

    fonts = {
      packages = with pkgs; [ nerd-fonts.fira-code ];
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

    programs.egui-greeter = {
      enable = true;
      default_session_name = "Niri";

      default_session_command = "niri-session";

      user = config.mysystem.user;
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

    hardware.graphics.enable32Bit = true;
    hardware.graphics.enable = true;
    hardware.graphics.package = pkgs.mesa;
  };
}
