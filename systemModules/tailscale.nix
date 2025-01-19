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
  options.mysystem.tailscale = {
    enable = mkOption {
      description = "enable system tailscale";
      type = lib.types.bool;
      default = false;
    };

    authkey = mkOption {
      description = "authkey location in sops";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config =
    let
      authkey = config.mysystem.tailscale.authkey;
    in
    mkIf config.mysystem.tailscale.enable {
      services.tailscale.enable = true;

      services.tailscale.authKeyFile = mkIf (authkey != null) config.sops.secrets."${authkey}".path;

      services.tailscale.openFirewall = true;

      sops.secrets."${authkey}" = mkIf (authkey != null) { };
    };
}
