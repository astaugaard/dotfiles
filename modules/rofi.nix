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
      terminal = "${pkgs.kitty}/bin/kitty";
      plugins = [
        (pkgs.rofi-calc.overrideAttrs (old: {
          # makes calc work with rofi-wayland
          buildInputs = [
            pkgs.rofi-wayland
            pkgs.libqalculate
            pkgs.glib
            pkgs.cairo
          ];
        }))
        pkgs.rofi-emoji-wayland
      ];

      # based on: https://github.com/adi1090x/rofi/blob/master/files/launchers/type-7/style-6.rasi
      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
          background = mkLiteral "#${config.lib.stylix.colors.base01}";
          background2 = mkLiteral "#${config.lib.stylix.colors.base00}";
          foreground = mkLiteral "#${config.lib.stylix.colors.base05}";
          accent = mkLiteral "#${config.lib.stylix.colors.base0E}";
          transparent = mkLiteral "transparent";
          vertical = mkLiteral "vertical";
          horizontal = mkLiteral "horizontal";
          center = mkLiteral "center";
          reuse = mkLiteral "inherit";
          pointer = mkLiteral "pointer";
          text = mkLiteral "text";
        in
        {
          "configuration" = {
            modi = "drun,filebrowser,window,ssh";
            show-icons = true;
            display-drun = "APPS";
            display-run = "RUN";
            display-filebrowser = "FILES";
            display-window = "WINDOWS";
            drun-display-format = "{name}";
            window-format = "{w} · {c}";
          };

          "window" = {
            transparency = "real";
            location = center;
            anchor = center;
            fullscreen = false;
            width = mkLiteral "1000px";
            x-offset = mkLiteral "0px";

            border-color = accent;
            y-offset = mkLiteral "0px";

            # properties  =or all widgets
            enabled = true;
            border-radius = mkLiteral "15px";
            cursor = "default";
            background-color = background;
            border = 2;
          };

          "mainbox" = {
            enabled = true;
            spacing = mkLiteral "0px";
            background-color = transparent;
            orientation = vertical;
            children = map mkLiteral [
              "inputbar"
              "listbox"
            ];
          };

          "listbox" = {
            spacing = mkLiteral "20px";
            padding = mkLiteral "20px";
            background-color = transparent;
            orientation = vertical;
            children = map mkLiteral [
              "message"
              "listview"
            ];
          };

          /**
            ***----- Inputbar -----****
          */
          "inputbar" = {
            enabled = true;
            spacing = mkLiteral "10px";
            padding = mkLiteral "20px 60px";
            background-color = background2;
            text-color = foreground;
            orientation = horizontal;
            children = map mkLiteral [
              "textbox-prompt-colon"
              "entry"
              "dummy"
              "mode-switcher"
            ];
          };
          "textbox-prompt-colon" = {
            enabled = true;
            expand = false;
            str = "";
            padding = mkLiteral "12px 15px";
            border-radius = mkLiteral "100%";
            background-color = background2;
            text-color = reuse;
          };
          "entry" = {
            enabled = true;
            expand = false;
            width = mkLiteral "300px";
            padding = mkLiteral "12px 16px";
            border-radius = mkLiteral "100%";
            background-color = background2;
            text-color = reuse;
            cursor = text;
            placeholder = "Search";
            placeholder-color = reuse;
          };
          "dummy" = {
            expand = true;
            background-color = transparent;
          };

          /**
            ***----- Mode Switcher -----****
          */
          "mode-switcher" = {
            enabled = true;
            spacing = mkLiteral "10px";
            background-color = transparent;
            text-color = foreground;
          };
          "button" = {
            width = mkLiteral "80px";
            padding = mkLiteral "12px";
            border-radius = mkLiteral "100%";
            background-color = background2;
            text-color = reuse;
            cursor = pointer;
          };
          "button selected" = {
            background-color = accent;
            text-color = background;
          };

          "listview" = {
            enabled = true;
            columns = 6;
            lines = 3;
            cycle = true;
            dynamic = true;
            scrollbar = false;
            layout = vertical;
            reverse = false;
            fixed-height = true;
            fixed-columns = true;

            spacing = mkLiteral "10px";
            background-color = transparent;
            text-color = foreground;
            cursor = "default";
          };

          "element" = {
            enabled = true;
            spacing = mkLiteral "10px";
            padding = mkLiteral "10px";
            border-radius = mkLiteral "15px";
            background-color = transparent;
            text-color = foreground;
            cursor = pointer;
            orientation = vertical;
          };
          "element normal" = {
            background-color = reuse;
            text-color = reuse;
          };
          "element selected" = {
            background-color = accent;
            text-color = background;
          };
          "element-icon" = {
            background-color = transparent;
            text-color = reuse;
            size = mkLiteral "64px";
            cursor = reuse;
          };
          "element-text" = {
            background-color = transparent;
            text-color = reuse;
            cursor = reuse;
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.5";
          };

          "message" = {
            background-color = transparent;
          };
          "textbox" = {
            padding = mkLiteral "15px";
            border-radius = mkLiteral "15px";
            background-color = background2;
            text-color = foreground;
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.0";
          };
          "error-message" = {
            padding = mkLiteral "15px";
            border-radius = mkLiteral "15px";
            background-color = background;
            text-color = foreground;
          };
        };
    };
  };
}

# theme =
#   let
#     inherit (config.lib.formats.rasi) mkLiteral;
#     background = mkLiteral "#${config.lib.stylix.colors.base01}50";
#     background2 = mkLiteral "#${config.lib.stylix.colors.base00}";
#     foreground = mkLiteral "#${config.lib.stylix.colors.base05}";
#     accent = mkLiteral "#${config.lib.stylix.colors.base0E}";
#   in
#   {
#     "*" = {
#       background-color = background;
#       text-color = foreground;
#       border-color = foreground;
#       font = "Fira Code NF 10";
#     };

#     "window" = {
#       anchor = mkLiteral "north west";
#       location = mkLiteral "north west";
#       width = mkLiteral "100%";
#       fullscreen = true;
#       padding = mkLiteral "50px";
#       children = map mkLiteral [
#         "searchrow"
#         "listview"
#       ];
#     };

#     "searchrow" = {
#       orientation = mkLiteral "horizontal";
#       children = map mkLiteral [
#         "dummy"
#         "searchbar"
#         "dummy"
#       ];
#       expand = false;
#       background-color = mkLiteral "#0000";
#     };

#     "searchbar" = {
#       orientation = mkLiteral "horizontal";
#       border-radius = mkLiteral "100%";
#       border = 2;
#       border-color = accent;
#       background-color = mkLiteral "#0000";
#       children = map mkLiteral [ "entry" ];
#       expand = false;
#       padding = 10;
#     };

#     "listview" = {
#       layout = mkLiteral "vertical";
#       spacing = mkLiteral "45px";
#       lines = 10;
#       columns = 13;
#       fixed-columns = true;
#       background-color = mkLiteral "#0000";
#     };

#     "dummy" = {
#       expand = true;
#       background-color = mkLiteral "#0000";
#     };

#     "entry" = {
#       expand = false;
#       width = mkLiteral "10em";
#       placeholder = "search";
#       background-color = mkLiteral "#0000";
#     };

#     "element" = {
#       padding = mkLiteral "20px 20px";
#       orientation = mkLiteral "vertical";
#       squared = true;
#       background-color = mkLiteral "#0000";
#     };

#     "element-icon" = {
#       size = 90;
#       expand = false;
#       background-color = mkLiteral "#00000000";
#     };

#     "element-text" = {
#       expand = false;
#       background-color = mkLiteral "#00000000";
#       align = mkLiteral "center";
#       width = 24;
#     };
#     "element selected" = {
#       background-color = accent;
#       border-radius = mkLiteral "100%";
#     };
#   };
# theme =
#   let
#     inherit (config.lib.formats.rasi) mkLiteral;
#     background = mkLiteral "#${config.lib.stylix.colors.base01}";
#     background2 = mkLiteral "#${config.lib.stylix.colors.base00}";
#     foreground = mkLiteral "#${config.lib.stylix.colors.base05}";
#     accent = mkLiteral "#${config.lib.stylix.colors.base0E}";
#   in
#   {
#     "*" = {
#       background-color = background;
#       text-color = foreground;
#       border-color = foreground;
#       font = "Fira Code NF 10";
#     };
#     "window" = {
#       anchor = mkLiteral "center";
#       location = mkLiteral "center";
#       width = mkLiteral "200mm";
#       spacing = mkLiteral "10mm";
#       # fullscreen = true;
#       padding = mkLiteral "5mm";
#       children = map mkLiteral [
#         "searchrow"
#         "listview"
#       ];
#     };
#     "searchrow" = {
#       orientation = mkLiteral "horizontal";
#       children = map mkLiteral [
#         "searchbar"
#         "dumy"
#         "mode-switcher"
#       ];
#       expand = false;
#     };

#     "listview" = {
#       layout = mkLiteral "vertical";
#       spacing = mkLiteral "45px";
#       fixed-height = true;
#       lines = 2;
#       columns = 4;
#       fixed-columns = true;
#       background-color = mkLiteral "#0000";
#     };

#     "dummy" = {
#       expand = true;
#       background-color = mkLiteral "#0000";
#     };

#     "searchbar" = {
#       orientation = mkLiteral "horizontal";
#       border-radius = mkLiteral "100%";
#       border = 2;
#       border-color = accent;
#       background-color = mkLiteral "#0000";
#       children = map mkLiteral [ "entry" ];
#       expand = false;
#       padding = 10;
#     };

#     "entry" = {
#       expand = false;
#       width = mkLiteral "10em";
#       placeholder = "search";
#       background-color = mkLiteral "#0000";
#     };

#     "element" = {
#       # padding = mkLiteral "20px 20px";
#       orientation = mkLiteral "vertical";
#       squared = true;
#       background-color = mkLiteral "#0000";
#     };

#     "element-icon" = {
#       size = "40mm";
#       expand = false;
#       background-color = mkLiteral "#00000000";
#     };

#     "element-text" = {
#       expand = false;
#       background-color = mkLiteral "#00000000";
#       align = mkLiteral "center";
#       # width = 24;
#     };

#     "element selected" = {
#       background-color = accent;
#       border-radius = mkLiteral "10%";
#     };
#   };
