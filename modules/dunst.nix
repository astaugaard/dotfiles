{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib;
{
  options.myhome.dunst = {
    enable = mkOption {
      description = "enable shared parts of the \"de\"";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.decommon.enable {
    services.dunst.enable = true;
    services.dunst.settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        frame_width = 3;
        frame_color = "#${config.colorScheme.palette.base07}";
        transparency = 0;
        font = "Droid Sans 9";
        background = "#ff0000";
        corner_radius = 20;
        progress_bar_corner_radius = 5;
        progress_bar_frame_width = 0;
        highlight = "#${config.colorScheme.palette.base09}";
      };

      urgency_normal = {
        background = "#${config.colorScheme.palette.base00}";
        foreground = "#${config.colorScheme.palette.base05}";
        timeout = 10;
      };
    };
  };
}
