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
  pixelfed-user = "pixelfed";
in
{
  options.mysystem.pixelfed = {
    enable = mkOption {
      description = "enable freshrss";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.mysystem.pixelfed.enable {
    sops.secrets.pixelfed = { };

    sops.templates."pixelfed-secrets.env" = {
      content = ''
        APP_KEY=${config.sops.placeholder.pixelfed}
      '';

      owner = pixelfed-user;
    };

    users.users."${pixelfed-user}" = {
      isSystemUser = true;
      group = pixelfed-user;
    };

    users.groups."${pixelfed-user}" = { };

    containers.pixelfed =
      let
        secrets_env = config.sops.templates."pixelfed-secrets.env".path;
      in
      {
        autoStart = true;
        bindMounts."${secrets_env}" = {
          mountPoint = secrets_env;
          isReadOnly = true;
          hostPath = secrets_env;
        };
        config =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {

            services.pixelfed = {
              enable = true;
              package = pkgs-unstable.pixelfed;
              phpPackage = pkgs.php84;

              domain = "169.254.90.188:5000";
              user = pixelfed-user;

              secretFile = secrets_env;
              settings."APP_NAME" = "Pixelfed";
              settings."FORCE_HTTPS_URLS" = false;

              redis.createLocally = true;
              nginx = {
                listen = [
                  {
                    addr = "169.254.90.188";
                    port = 5000;
                    # ssl = true;
                  }
                  {
                    addr = "100.64.0.2";
                    port = 5000;
                    # ssl = true; // hopefully covered by caddy
                  }
                ];
              };
            };
            system.stateVersion = "24.11";
          };
      };
  };
}
