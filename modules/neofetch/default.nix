{pkgs, config, lib, ...}:
with builtins;
with lib;
{
    options.myhome.neofetch = {
        enable = mkOption {
            description = "enable neofetch";
            type = lib.types.bool;
            default = false;
        };
    };

    config = mkIf config.myhome.neofetch.enable {
      home.packages = with pkgs; [
        neofetch
        hyfetch
      ];
      xdg.configFile."neofetch".source = ./. ;
    };
}
