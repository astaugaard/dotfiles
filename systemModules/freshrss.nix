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
  options.mysystem.freshrss = {
    enable = mkOption {
      description = "enable freshrss";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.mysystem.freshrss.enable {
    sops.secrets.freshrss-password = {
      owner = freshrss-user;
    };

    users.users."${freshrss-user}" = {
      isSystemUser = true;
      group = freshrss-user;
    };

    users.groups."${freshrss-user}" = { };

    containers.freshrss =
      let
        passwordFile = config.sops.secrets.freshrss-password.path;
      in
      {

        autoStart = true;
        bindMounts."/run/secrets/freshrss-password" = {
          mountPoint = "/run/secrets/freshrss-password";
          isReadOnly = true;
          hostPath = "/run/secrets/freshrss-password";
        };

        bindMounts."/etc/resolv.conf" = {
          hostPath = "/etc/resolv.conf";
          isReadOnly = true;
        };

        config =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            services.cron = {
              enable = true;

              systemCronJobs = [
                "10 * * * * www-data ${pkgs.php}/bin/php -f ${pkgs.freshrss}/app/actualize_script.php > /tmp/FreshRSS.log 2>&1"
              ];
            };

            services.freshrss = {
              enable = true;
              passwordFile = passwordFile;
              defaultUser = "a";
              baseUrl = "169.254.80.188:8000";
              user = freshrss-user;
              authType = "none";
            };
            system.stateVersion = "24.11";
          };
      };
  };
}
