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
  options.mysystem.flatpak = {
    enable = mkOption {
      description = "enable system flatpak stuff";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.mysystem.flatpak.enable {
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    services.flatpak.enable = true;
  };
}
