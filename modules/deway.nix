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
        wl-clipboard
      ];
      programs.swaylock.enable = true;
      programs.swaylock.settings = {
          image = "${lib.fileset.toSource { root = ./.; fileset = ./lock.png; }}/lock.png";
      };
      myhome.swaync.enable = true;

      services.swayidle = {
        enable = true;
        events = [
            { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -fF --image ~/Dropbox/lock.png"; }
        ];
      };
    };
}
