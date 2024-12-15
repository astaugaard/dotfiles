{ standalone, ... }:
if standalone then
  (
    {
      pkgs,
      config,
      lib,
      pkgs-unstable,
      ...
    }:
    with builtins;
    with lib;
    {
      options.myhome.niri = {
        enable = lib.mkOption {
          description = "enable niri";
          type = lib.types.bool;
          default = false;
        };
      };

      config = mkIf config.myhome.niri.enable {
        programs.niri.enable = true;
        programs.niri.package = pkgs.niri-stable;

        programs.niri.settings = import ./settings.nix {
          inherit pkgs;
          inherit config;
          inherit lib;
        };

        myhome.decommon.enable = true;
        myhome.deway.enable = true;

        services.swayidle = {
          enable = true;
          events = [
            {
              event = "before-sleep";
              command = "${pkgs.swaylock}/bin/swaylock -fF";
            }
          ];
          timeouts = [
            {
              timeout = 120;
              command = "${pkgs.niri-stable}/bin/niri msg action power-off-monitors";
            }
            {
              timeout = 180;
              command = "${pkgs.swaylock}/bin/systemctl hybrid-sleep";
            }
          ];
        };
      };
    }
  )
else
  { }
