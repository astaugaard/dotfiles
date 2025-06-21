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

      };
    }
  )
else
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
    config = {
      programs.niri.package = pkgs.niri-stable;

      programs.niri.settings = import ./settings.nix {
        inherit pkgs;
        inherit config;
        inherit lib;
      };

      myhome.decommon.enable = true;
      myhome.deway.enable = true;

    };
  }
