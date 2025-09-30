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
      xorg.xeyes
      nix-index
      ripgrep
      alsa-utils
      qrcp
      (makeDesktopItem rec {
        name = "bluetui-desktop";
        desktopName = "bluetui";
        exec = "${pkgs.kitty}/bin/kitty ${pkgs.bluetui}/bin/bluetui";
        icon = "bluetooth";
      })
      (makeDesktopItem rec {
        name = "pairdrop";
        desktopName = "pairdrop";
        exec = "${pkgs.chromium}/bin/chromium --app=\"https://pairdrop.net\"";
        icon = pkgs.fetchurl {
          url = "https://github.com/schlagmichdoch/PairDrop/raw/master/public/images/android-chrome-512x512.png";
          hash = "sha256-BGxMhMZwU0Gw6nA0TPn1ffr5x6HTmaJoymif+fM2KCI=";
          name = "pairdrop-icon";
        };
      })
    ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };
  };
}
