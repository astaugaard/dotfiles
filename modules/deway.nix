{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib;
let
  lockscreen = pkgs.stdenv.mkDerivation rec {
    name = "lockscreen";
    src = lib.fileset.toSource {
      root = ./.;
      fileset = ./lock.svg;
    };
    foreground = "#${config.lib.stylix.colors.base09}";

    buildPhase = ''
      substituteAllInPlace lock.svg
    '';

    installPhase = ''
      mkdir $out

      ${pkgs.inkscape}/bin/inkscape --export-type "png" --export-filename "$out/lock.png" lock.svg
    '';
  };
in
{
  options.myhome.deway = {
    enable = mkOption {
      description = "enable shared parts of the \"de\"";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.deway.enable {
    home.packages = with pkgs; [
      swaybg
      wl-clipboard
    ];
    # myhome.desktop.enable = true;
    programs.swaylock.enable = true;
    home.sessionVariables.WLR_RENDERER = "vulkan";

    myhome.waybar.enable = true;

    stylix.targets.swaylock.useImage = false;

    programs.swaylock.settings = {
      image = "${lockscreen}/lock.png";
    };
    myhome.swaync.enable = true;

    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -fF --image ~/Dropbox/lock.png";
        }
      ];
    };
  };
}
