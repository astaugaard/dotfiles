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
  options.mysystem.egui-greeter = {
    enable = mkOption {
      description = "enable egui-greeter";
      type = lib.types.bool;
      default = false;
    };

    default_session_name = mkOption {
      description = "default session name";
      type = lib.types.str;
    };

    default_session_command = mkOption {
      description = "default session command";
      type = lib.types.str;
    };

    user = mkOption {
      description = "default session command";
      type = lib.types.str;
    };
  };

  config = mkIf config.mysystem.egui-greeter.enable {
    environment.etc = {
      "greetd/egui-greeter.json".source = pkgs.writeText "config.json" (
        lib.generators.toJSON { } {
          default_session_name = config.mysystem.egui-greeter.default_session_name;
          default_session_command = config.mysystem.egui-greeter.default_session_command;
          user = config.mysystem.egui-greeter.user;
        }
      );
    };
  };
}
