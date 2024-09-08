{pkgs, config, lib, ...}:
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
      home.packages = with pkgs; [
        rofi
      ];
      xdg.configFile."rofi".source = ./. ;
    };
}
