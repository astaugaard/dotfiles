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
  };

  config = mkIf config.mysystem.tailscale.enable {
    services.tailscale.enable = true;
  };
}
