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
        home.packages = [ pkgs.fish ];

#        programs.fish.enable = true;
#        programs.fish.shellInit = builtins.readFile(./config.fish);
    };
}
