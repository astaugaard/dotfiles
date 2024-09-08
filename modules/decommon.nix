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
        dunst
        nautilus
        galculator
        xorg.xclock
        scrot
        maestral-gui
        gnome-software
        librewolf
        flatpak
        sassc
        beauty-line-icon-theme
        greatVibes
      ];
      myhome.kitty.enable = true;
      myhome.rofi.enable = true;
    };
}
