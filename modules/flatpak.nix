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
  options.myhome.flatpak = {
    enable = mkOption {
      description = "enable shared parts of the \"de\"";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.flatpak.enable {
    home.packages = with pkgs; [
      gnome.gnome-software
      flatpak
    ];

    xdg.systemDirs.data = [
      "/usr/share"
      "/var/lib/flatpak/exports/share"
      "~/.local/share/flatpak/exports/share"
    ];
  };
}
