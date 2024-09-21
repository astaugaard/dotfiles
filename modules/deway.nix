{pkgs, config, lib, ...}:
with builtins;
with lib;
{
    options.myhome.deway= {
        enable = mkOption {
            description = "enable shared parts of the \"de\"";
            type = lib.types.bool;
            default = false;
        };
    };

    config = mkIf config.myhome.deway.enable {
      home.packages = with pkgs; [
        swaybg
        slurp
        wl-clipboard
        # wmctrl
        # nitrogen
        # xdotool
        # dmenu
        # xclip
        # i3lock
      ];
      programs.swaylock.enable = true;
      programs.swaylock.settings = {
          image = "${lib.fileset.toSource { root = ./.; fileset = ./lock.png; }}/lock.png";
      };
    };
}
