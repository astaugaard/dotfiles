{pkgs, config, lib, ...}:
with builtins;
with lib;
{
    options.myhome.picom = {
        enable = mkOption {
            description = "enable picom";
            type = lib.types.bool;
            default = false;
        };
    };

    config = mkIf config.myhome.kitty.enable {
      home.packages = with pkgs; [
        picom
      ];
      xdg.configFile."picom".source = ./.;
    };
}
