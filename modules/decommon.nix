{pkgs, config, lib, ...}:
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
        eww
        lxappearance
        libnotify
        gnome.nautilus
        galculator
        xorg.xclock
        scrot
        maestral-gui
        gnome.gnome-software
        librewolf
        flatpak
        sassc
        beauty-line-icon-theme
        pywal
      ];

      myhome.kitty.enable = true;
      myhome.rofi.enable = true;
      myhome.swaync.enable = true;
    };
}
