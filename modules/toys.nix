{pkgs, config, lib, ...}:
with builtins;
with lib;
{
    options.myhome.toys = {
        enable = mkOption {
            description = "enable toys";
            type = lib.types.bool;
            default = false;
        };
    };

    config = mkIf config.myhome.toys.enable {
      home.packages = with pkgs; [
        neofetch
        hyfetch
        catsay
        fortune
        cbonsai
        cmatrix
        lolcat
        prideful
      ];
      myhome.neofetch.enable = true;
    };
}

