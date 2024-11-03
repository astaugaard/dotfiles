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
  options.myhome.rofi = {
    enable = mkOption {
      description = "enable rofi";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.rofi.enable {
    stylix.targets.rofi.enable = false;

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;

      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
          background = mkLiteral "#${config.lib.stylix.colors.base01}50";
          background2 = mkLiteral "#${config.lib.stylix.colors.base00}";
          foreground = mkLiteral "#${config.lib.stylix.colors.base05}";
          accent = mkLiteral "#${config.lib.stylix.colors.base0E}";
        in
        {
          "*" = {
            background-color = background;
            text-color = foreground;
            border-color = foreground;
            font = "Fira Code NF 10";
          };

          "window" = {
            anchor = mkLiteral "north west";
            location = mkLiteral "north west";
            width = mkLiteral "100%";
            fullscreen = true;
            padding = mkLiteral "50px";
            children = map mkLiteral [
              "searchrow"
              "listview"
            ];
          };

          "searchrow" = {
            orientation = mkLiteral "horizontal";
            children = map mkLiteral [
              "dummy"
              "searchbar"
              "dummy"
            ];
            expand = false;
            background-color = mkLiteral "#0000";
          };

          "searchbar" = {
            orientation = mkLiteral "horizontal";
            border-radius = mkLiteral "100%";
            border = 2;
            border-color = accent;
            background-color = mkLiteral "#0000";
            children = map mkLiteral [ "entry" ];
            expand = false;
            padding = 10;
          };

          "listview" = {
            layout = mkLiteral "vertical";
            spacing = mkLiteral "45px";
            lines = 10;
            columns = 13;
            fixed-columns = true;
            background-color = mkLiteral "#0000";
          };

          "dummy" = {
            expand = true;
            background-color = mkLiteral "#0000";
          };

          "entry" = {
            expand = false;
            width = mkLiteral "10em";
            placeholder = "search";
            background-color = mkLiteral "#0000";
          };

          "element" = {
            padding = mkLiteral "20px 20px";
            orientation = mkLiteral "vertical";
            squared = true;
            background-color = mkLiteral "#0000";
          };

          "element-icon" = {
            size = 90;
            expand = false;
            background-color = mkLiteral "#00000000";
          };

          "element-text" = {
            expand = false;
            background-color = mkLiteral "#00000000";
            align = mkLiteral "center";
            width = 24;
          };
          "element selected" = {
            background-color = accent;
            border-radius = mkLiteral "100%";
          };
        };
    };

    # home.packages = with pkgs; [ rofi-wayland ];

    # stylix.targets.rofi.enable = false;

    # xdg.configFile."rofi".source = pkgs.substituteAllFiles {
    #   src = ./.;
    #   files = [
    #     "config.rasi"
    #     "themes/launcher.rasi"
    #     "themes/rounded-common.rasi"
    #   ];
    #   background = "#${config.lib.stylix.colors.base01}50";
    #   background2 = "#${config.lib.stylix.colors.base00}";
    #   foreground = "#${config.lib.stylix.colors.base05}";
    #   accent = "#${config.lib.stylix.colors.base0E}";
    # };
  };
}
