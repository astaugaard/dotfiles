{pkgs, config, lib, ...}:
with builtins;
with lib;
{
    options.myhome.kitty = {
        enable = mkOption {
            description = "enable kitty";
            type = lib.types.bool;
            default = false;
        };
    };

    config = mkIf config.myhome.kitty.enable {
      home.packages = with pkgs; [
        kitty
      ];
      xdg.configFile."kitty".source = ./. ;
    };
}
