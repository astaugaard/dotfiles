{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  ...
}:
with builtins;
with lib;
let
  freshrss-user = "freshrss";
in
{
  options.mysystem.invidious = {
    enable = mkOption {
      description = "enable invidious";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.mysystem.invidious.enable {
    containers.invidious = {
      autoStart = true;
      config =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          services.invidious = {
            enable = true;
            sig-helper.enable = true;
            http3-ytproxy.enable = true;
            settings = {
              popular_enabled = false;
            };
          };
          services.postgresql.enable = true;
          system.stateVersion = "24.11";
        };
    };
  };
}
