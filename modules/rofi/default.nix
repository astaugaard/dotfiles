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

    stylix.targets.rofi.enable = false;

    xdg.configFile."rofi".source = pkgs.substituteAllFiles {
      src = ./.;
      files = [
        "config.rasi"
        "themes/launcher.rasi"
        "themes/rounded-common.rasi"
      ];
      background = "#${config.lib.stylix.colors.base01}50";
      background2 = "#${config.lib.stylix.colors.base00}";
      foreground = "#${config.lib.stylix.colors.base05}";
      accent = "#${config.lib.stylix.colors.base0E}";
    };
  };
}
