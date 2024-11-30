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

    # needed for flatpaks to work
    xdg.portal.enable = true;

    xdg.portal.wlr = {
      enable = true;
    };

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];

    xdg.portal.config = {
      common = {
        default = [ "gtk" ];
      };
      # sway = {
      #   default = [
      #     "gtk"
      #     "wlr"
      #   ];
      # };
      niri = {
        default = [
          "gnome"
          "gtk"
          "wlr"
        ];
      };
    };
  };
}
