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
  options.mysystem.freshrss = {
    enable = mkOption {
      description = "enable freshrss";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.mysystem.freshrss.enable {
    services.freshrss = {
      enable = true;
      passwordFile = config.sops.secrets.freshrss-password.path;
      defaultUser = "a";
      baseUrl = "169.254.80.188:8000";
    };
    sops.secrets.freshrss-password = { };
  };
}
