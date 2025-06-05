{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib;
let
  # tex = pkgs.texlive.combine { inherit (pkgs.texlive) scheme-tetex standalone preview; };
  mybackground = pkgs.stdenv.mkDerivation rec {
    name = "mybackground";
    src = lib.fileset.toSource {
      root = ./.;
      fileset = ./butterfly.svg;
    };
    background = "#${config.lib.stylix.colors.base01}";
    foreground = "#${config.lib.stylix.colors.base0E}";

    buildPhase = ''
      substituteAllInPlace butterfly.svg
    '';

    installPhase = ''
      mkdir $out

      ${pkgs.inkscape}/bin/inkscape --export-type "png" --export-filename "$out/butterfly.png" butterfly.svg
    '';
  };
in
{
  options.myhome.colors = {
    background = mkOption {
      description = "path to background file";
      type = lib.types.path;
      default = "${mybackground}/butterfly.png";
    };

    dark = mkOption {
      description = "polarity for stylix";
      type = lib.types.bool;
      default = true;
    };

    colorscheme = mkOption {
      description = "color scheme to set using base16-schemes";
      type = lib.types.str;
      default = "catppuccin-macchiato";
    };

    base16path = mkOption {
      description = "base16 theme path";
      type = lib.types.path;
      default = "${pkgs.base16-schemes}/share/themes/${config.myhome.colors.colorscheme}.yaml";
    };
  };

  config = {
    stylix.enable = true;

    stylix.polarity = if config.myhome.colors.dark then "dark" else "light";
    stylix.base16Scheme = config.myhome.colors.base16path;
    stylix.image = config.myhome.colors.background;
  };
}
