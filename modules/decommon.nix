{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib;
{
  options.myhome.decommon = {
    enable = mkOption {
      description = "enable shared parts of the \"de\"";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.decommon.enable {
    home.packages = with pkgs; [
      libnotify
      nautilus
      scrot
      beauty-line-icon-theme
      librewolf
    ];

    myhome.kitty.enable = true;
    myhome.rofi.enable = true;
    myhome.swaync.enable = true;

    gtk.enable = true;
    gtk.iconTheme = {
      name = "BeautyLine";
      package = pkgs.beauty-line-icon-theme;
    };

  };
}
