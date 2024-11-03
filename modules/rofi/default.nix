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
  options.myhome.rofi = {
    enable = mkOption {
      description = "enable rofi";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.rofi.enable {
    home.packages = with pkgs; [ rofi-wayland ];
    xdg.configFile."rofi".source = pkgs.substituteAllFiles {
      src = ./.;
      files = [
        "config.rasi"
        "themes/launcher.rasi"
        "themes/rounded-common.rasi"
      ];
      background = "#${config.colorScheme.palette.base01}50";
      background2 = "#${config.colorScheme.palette.base00}";
      foreground = "#${config.colorScheme.palette.base05}";
      accent = "#${config.colorScheme.palette.base0E}";
    };
  };
}
