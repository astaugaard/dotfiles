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
  options.myhome.desktop = {
    enable = mkOption {
      description = "enable shared parts of the \"de\"";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.desktop.enable {
    home.packages = with pkgs; [
      galculator
      xorg.xclock
      bitwarden-desktop
      pkgs-unstable.dropbox-cli
      qemu
      nix-index
      alsa-utils
    ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
    };

    systemd.user.services.dropbox = {
      Unit = {
        Description = "Dropbox service";
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