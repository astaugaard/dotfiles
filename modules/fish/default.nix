{pkgs, config, lib, ...}:
with builtins;
with lib;
{
    options.myhome.fish = {
        enable = mkOption {
            description = "enable fish";
            type = lib.types.bool;
            default = true;
        };
    };

    config = mkIf config.myhome.fish.enable {
      home.packages = with pkgs; [
          fish
      ];
      xdg.configFile."fish".source = ./. ;
    };
}
