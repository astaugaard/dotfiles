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
    sops.secrets.pixelfed = {
      # owner = freshrss-user;
    };

    sops.templates."pixelfed-secrets.env" = {
      content = ''
        APP_KEY=${config.sops.placeholder.pixelfed}
      '';

      owner = pixelfed-user;
    };

    users.users."${freshrss-user}" = {
      isSystemUser = true;
      group = freshrss-user;
    };

    users.groups."${freshrss-user}" = { };

    containers.freshrss =
      let
        secrets_env = config.sops.templates."pixelfed-secret.env".path;
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
              domain = "pixefed.staugaard.xyz";
              user = pixelfed-user;
              secretsFile = secrets_env;
              settings."FORCE_HTTPS_URLS" = false;
              settings."APP_NAME" = "Pixelfed";

              redis.createLocally = true;
              nginx = {
                listen = [
                  {
                    addr = "127.0.0.1";
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
