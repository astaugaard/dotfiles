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

    port = mkOption {
      description = "port for invidious to listen on";
      type = lib.types.int;
      default = 3000;
    };
  };

  config = mkIf config.mysystem.invidious.enable {
    networking.firewall.allowedTCPPorts = [ config.mysystem.invidious.port ];

    containers.invidious = {
      autoStart = true;
      bindMounts."/etc/resolv.conf" = {
        hostPath = "/etc/resolv.conf";
        isReadOnly = true;
      };
      config =
        {
          # config,
          pkgs,
          lib,
          ...
        }:
        {
          services.invidious = {
            enable = true;
            sig-helper.enable = true;
            http3-ytproxy.enable = true;
            port = config.mysystem.invidious.port;
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
