{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib;
{
  options.myhome.swaync = {
    enable = mkOption {
      description = "enable shared parts of the \"de\"";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.swaync.enable {
    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        cssPriority = "application";
        control-center-margin-top = 0;
        control-center-margin-bottom = 0;
        control-center-margin-right = 0;
        control-center-margin-left = 0;
        control-center-height = 600;
        notification-2fa-action = true;
        notification-inline-replies = false;
        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        widgets = [
          "title"
          "inhibitors"
          "dnd"
          "mpris"
          "notifications"
        ];
      };
      style = pkgs.fetchurl {
        url = "https://github.com/catppuccin/swaync/releases/download/v0.2.3/macchiato.css";
        hash = "sha256-LMm6nWn1JPPgj5YpppwFG3lXTtXem5atlIvqrDxd0bM=";
      };
    };
  };
}
