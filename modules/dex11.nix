{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib;
{
  options.myhome.dex11 = {
    enable = mkOption {
      description = "enable shared parts of the \"de\"";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.dex11.enable {
    home.packages = with pkgs; [
      wmctrl
      nitrogen
      xdotool
      dmenu
      xclip
      i3lock
    ];

    myhome.dunst.enable = false;
    myhome.picom.enable = true;
  };
}
