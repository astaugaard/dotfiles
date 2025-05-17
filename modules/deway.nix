{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib;
let
  # lockscreen = pkgs.substituteAll {
  #   foreground = "#${config.lib.stylix.colors.base09}";
  #   src = ./lock.svg;
  # };
  lockscreen = pkgs.stdenv.mkDerivation rec {
    name = "lockscreen";
    src = lib.fileset.toSource {
      root = ./.;
      fileset = ./lock.svg;
    };
    foreground = "#${config.lib.stylix.colors.base09}";

    buildPhase = ''
      substituteAllInPlace lock.svg
    '';

    installPhase = ''
      mkdir $out

      ${pkgs.inkscape}/bin/inkscape --export-type "png" --export-filename "$out/lock.png" lock.svg
    '';
  };

in
#     # ${pkgs.inkscape}/bin/inkscape --export-type "png" --export-filename "$out/lock.png" lock.svg
#   '';
# };
{
  options.myhome.deway = {
    enable = mkOption {
      description = "enable shared parts of the \"de\"";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.deway.enable {
    home.packages = with pkgs; [
      swaybg
      wl-clipboard
    ];
    # myhome.desktop.enable = true;

    home.sessionVariables.WLR_RENDERER = "vulkan";
    myhome.decommon.enable = true;

    myhome.waybar.enable = true;
    myhome.swaync.enable = true;

    stylix.targets.swaylock.useImage = false;

    programs.swaylock.enable = true;
    programs.swaylock.package = pkgs.swaylock-effects;

    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
      ];
      timeouts = [
        {
          timeout = 120;
          command = "${pkgs.niri-stable}/bin/niri msg action power-off-monitors";
        }
        {
          timeout = 180;
          command = "${pkgs.swaylock}/bin/systemctl hybrid-sleep";
        }
      ];
    };

    programs.swaylock.settings = {
      effect-pixelate = 20;
      screenshots = true;
      # effect-compose = "${lockscreen}/lock.png";
    };
  };
}
