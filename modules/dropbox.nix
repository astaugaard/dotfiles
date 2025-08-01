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
  options.myhome.dropbox = {
    enable = mkOption {
      description = "enable dropbox";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.dropbox.enable {
    home.packages = with pkgs; [ pkgs-unstable.dropbox-cli ];

    systemd.user.services.dropbox = {
      Unit = {
        Description = "Dropbox service";
        Wants = [ "waybar" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs-unstable.dropbox}/bin/dropbox";
        Restart = "on-failure";
      };
    };
  };
}
