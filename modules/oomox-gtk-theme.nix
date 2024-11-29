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
  options.myhome.oomox =
    let
      colortype = lib.types.strMatching "[a-f0-9]\{3,6\}"; # might have to change this to 8 bc alpha channel idk if this supports that though
    in
    {
      enable = mkOption {
        description = "enable oomox";
        type = lib.types.bool;
        default = false;
      };

      accent_bg = mkOption {
        description = "accent bg color";
        type = colortype;
        default = config.lib.stylix.colors.base01;
      };

      bg = mkOption {
        description = "bg color";
        type = colortype;
        default = config.lib.stylix.colors.base00;
      };

      btn_bg = mkOption {
        description = "the color of btn_bg";
        type = colortype;
        default = config.lib.stylix.colors.base01;
      };

      btn_fg = mkOption {
        description = "the color of btn_fg";
        type = colortype;
        default = config.lib.stylix.colors.base05;
      };

      caret1_fg = mkOption {
        description = "the color of caret1_fg";
        type = colortype;
        default = config.lib.stylix.colors.base05;
      };

      caret2_fg = mkOption {
        description = "the color of caret2_fg";
        type = colortype;
        default = config.lib.stylix.colors.base05;
      };

      fg = mkOption {
        description = "the color of fg";
        type = colortype;
        default = config.lib.stylix.colors.base05;
      };

      hdr_btn_bg = mkOption {
        description = "the color of hdr_btn_bg";
        type = colortype;
        default = config.lib.stylix.colors.base0E;
      };

      hdr_btn_fg = mkOption {
        description = "the color of hdr_btn_fg";
        type = colortype;
        default = config.lib.stylix.colors.base00;
      };

      icons_archdroid = mkOption {
        description = "the color of icons_archdroid";
        type = colortype;
        default = config.lib.stylix.colors.base00;
      };

      icons_dark = mkOption {
        description = "the color of icons_dark";
        type = colortype;
        default = config.lib.stylix.colors.base05;
      };

      icons_light = mkOption {
        description = "the color of icons_light";
        type = colortype;
        default = config.lib.stylix.colors.base00;
      };

      icons_light_folder = mkOption {
        description = "the color of icons_light_folder";
        type = colortype;
        default = config.lib.stylix.colors.base00;
      };

      icons_medium = mkOption {
        description = "the color of icons_medium";
        type = colortype;
        default = config.lib.stylix.colors.base05;
      };

      hdr_bg = mkOption {
        description = "the color of hdr_bg";
        type = colortype;
        default = config.lib.stylix.colors.base0F;
      };

      hdr_fg = mkOption {
        description = "the color of hdr_fg";
        type = colortype;
        default = config.lib.stylix.colors.base01;
      };

      sel_bg = mkOption {
        description = "the color of sel_bg";
        type = colortype;
        default = config.lib.stylix.colors.base02;
      };

      sel_fg = mkOption {
        description = "the color of sel_fg";
        type = colortype;
        default = config.lib.stylix.colors.base05;
      };

      terminal_accent_color = mkOption {
        description = "the color of terminal_accent_color";
        type = colortype;
        default = config.lib.stylix.colors.base0E;
      };

      terminal_background = mkOption {
        description = "the color of terminal_background";
        type = colortype;
        default = config.lib.stylix.colors.base00;
      };

      terminal_color0 = mkOption {
        description = "the color of terminal_color0";
        type = colortype;
        default = config.lib.stylix.colors.base00;
      };

      terminal_color1 = mkOption {
        description = "the color of terminal_color1";
        type = colortype;
        default = config.lib.stylix.colors.base01;
      };

      terminal_color10 = mkOption {
        description = "the color of terminal_color10";
        type = colortype;
        default = config.lib.stylix.colors.base0A;
      };

      terminal_color11 = mkOption {
        description = "the color of terminal_color11";
        type = colortype;
        default = config.lib.stylix.colors.base0B;
      };

      terminal_color12 = mkOption {
        description = "the color of terminal_color12";
        type = colortype;
        default = config.lib.stylix.colors.base0C;
      };

      terminal_color13 = mkOption {
        description = "the color of terminal_color13";
        type = colortype;
        default = config.lib.stylix.colors.base0D;
      };

      terminal_color14 = mkOption {
        description = "the color of terminal_color14";
        default = config.lib.stylix.colors.base0E;
        type = colortype;
      };

      terminal_color15 = mkOption {
        description = "the color of terminal_color15";
        default = config.lib.stylix.colors.base0F;
        type = colortype;
      };

      terminal_color2 = mkOption {
        description = "the color of terminal_color2";
        default = config.lib.stylix.colors.base02;
        type = colortype;
      };

      terminal_color3 = mkOption {
        description = "the color of terminal_color3";
        default = config.lib.stylix.colors.base03;
        type = colortype;
      };

      terminal_color4 = mkOption {
        description = "the color of terminal_color4";
        default = config.lib.stylix.colors.base04;
        type = colortype;
      };

      terminal_color5 = mkOption {
        description = "the color of terminal_color5";
        default = config.lib.stylix.colors.base05;
        type = colortype;
      };

      terminal_color6 = mkOption {
        description = "the color of terminal_color6";
        default = config.lib.stylix.colors.base06;
        type = colortype;
      };

      terminal_color7 = mkOption {
        description = "the color of terminal_color7";
        default = config.lib.stylix.colors.base07;
        type = colortype;
      };

      terminal_color8 = mkOption {
        description = "the color of terminal_color8";
        default = config.lib.stylix.colors.base08;
        type = colortype;
      };

      terminal_color9 = mkOption {
        description = "the color of terminal_color9";
        default = config.lib.stylix.colors.base09;
        type = colortype;
      };

      terminal_foreground = mkOption {
        default = config.lib.stylix.colors.base05;
        description = "the color of terminal_foreground";
        type = colortype;
      };

      txt_bg = mkOption {
        description = "the color of txt_bg";
        type = colortype;
        default = config.lib.stylix.colors.base00;
      };

      txt_fg = mkOption {
        description = "the color of txt_fg";
        default = config.lib.stylix.colors.base05;
        type = colortype;
      };

      wm_border_focus = mkOption {
        description = "the color of wm_border_focus";
        default = config.lib.stylix.colors.base0E;
        type = colortype;
      };

      wm_border_unfocus = mkOption {
        description = "the color of wm_border_unfocus";
        default = config.lib.stylix.colors.base00;
        type = colortype;
      };

      spotify_proto_bg = mkOption {
        description = "idk";
        type = colortype;
        default = config.lib.stylix.colors.base00;
      };

      spotify_proto_fg = mkOption {
        description = "idk";
        type = colortype;
        default = config.lib.stylix.colors.base05;

      };

      spotify_proto_sel = mkOption {
        description = "idk";
        type = colortype;
        default = config.lib.stylix.colors.base02;

      };

      btn_outline_offset = mkOption {
        description = "btn_outline_offset in pixels?";
        type = lib.types.ints.unsigned;
        default = 1;
      };

      btn_outline_width = mkOption {
        description = "btn_outline_width in pixels?";
        type = lib.types.ints.unsigned;
        default = 2;
      };

      outline_width = mkOption {
        description = "outline_width in pixels?";
        type = lib.types.ints.unsigned;
        default = 1;
      };

      roundness = mkOption {
        description = "roundness in pixels?";
        type = lib.types.ints.unsigned;
        default = 4;
      };

      spacing = mkOption {
        description = "spacing in pixels?";
        type = lib.types.ints.unsigned;
        default = 3;
      };

      caret_size = mkOption {
        description = "CARET_SIZE variable in oomox";
        type = lib.types.numbers.nonnegative;
        default = 4.0e-2;
      };

      gnome_shell_panel_opacity = mkOption {
        description = "GNOME_SHELL_PANEL_OPACITY variable in oomox";
        type = lib.types.numbers.nonnegative;
        default = 0.6;
      };

      gradient = mkOption {
        description = "GRADIENT variable in oomox";
        type = lib.types.numbers.nonnegative;
        default = 0.0;
      };

      gtk3_generate_dark = mkOption {
        type = lib.types.bool;
        description = "generate dark";
        default = false;
      };

      terminal_theme_auto_bgfg = mkOption {
        type = lib.types.bool;
        description = "generate dark";
        default = true;
      };

      unity_default_launcher_style = mkOption {
        type = lib.types.bool;
        description = "idk";
        default = true;
      };

      materia_style_compact = mkOption {
        type = lib.types.bool;
        description = "weather to make materia style compact";
        default = true;
      };

      name = mkOption {
        type = lib.types.str;
        description = "name idk";
        default = "stylix/oomox/gtk";
      };

      terminal_base_template = mkOption {
        type = lib.types.str;
        description = "idk";
        default = "waltz2";
      };

      terminal_theme_mode = mkOption {
        type = lib.types.str;
        description = "idk";
        default = "manual";
      };

      theme_style = mkOption {
        type = lib.types.str;
        description = "idk";
        default = "oomox";
      };

      icons_style = mkOption {
        type = lib.types.str;
        description = "idk";
        default = "gnome_colors";
      };
    };

  config = mkIf config.myhome.oomox.enable ({
    gtk.theme.package =
      let
        boolshow = bool: if bool then "True" else "False";
        themeconfig = pkgs.writeText "config" ''
          ACCENT_BG=${config.myhome.oomox.accent_bg}
          BG=${config.myhome.oomox.bg}
          BTN_BG=${config.myhome.oomox.btn_bg}
          BTN_FG=${config.myhome.oomox.btn_fg}
          BTN_OUTLINE_OFFSET=${builtins.toString config.myhome.oomox.btn_outline_offset}
          BTN_OUTLINE_WIDTH=${builtins.toString config.myhome.oomox.btn_outline_width}
          CARET1_FG=${config.myhome.oomox.caret1_fg}
          CARET2_FG=${config.myhome.oomox.caret2_fg}
          CARET_SIZE=${builtins.toString config.myhome.oomox.caret_size}
          FG=${config.myhome.oomox.fg}
          GNOME_SHELL_PANEL_OPACITY=${builtins.toString config.myhome.oomox.gnome_shell_panel_opacity}
          GRADIENT=${builtins.toString config.myhome.oomox.gradient}
          GTK3_GENERATE_DARK=${boolshow config.myhome.oomox.gtk3_generate_dark}
          HDR_BTN_BG=${config.myhome.oomox.hdr_btn_bg}
          HDR_BTN_FG=${config.myhome.oomox.hdr_btn_fg}
          ICONS_ARCHDROID=${config.myhome.oomox.icons_archdroid}
          ICONS_DARK=${config.myhome.oomox.icons_dark}
          ICONS_LIGHT=${config.myhome.oomox.icons_light}
          ICONS_LIGHT_FOLDER=${config.myhome.oomox.icons_light_folder}
          ICONS_MEDIUM=${config.myhome.oomox.icons_medium}
          ICONS_STYLE=${config.myhome.oomox.icons_style}
          MATERIA_STYLE_COMPACT=${boolshow config.myhome.oomox.materia_style_compact}
          HDR_BG=${config.myhome.oomox.hdr_bg}
          HDR_FG=${config.myhome.oomox.hdr_fg}
          NAME=${config.myhome.oomox.name}
          OUTLINE_WIDTH=${builtins.toString config.myhome.oomox.outline_width}
          ROUNDNESS=${builtins.toString config.myhome.oomox.roundness}
          SEL_BG=${config.myhome.oomox.sel_bg}
          SEL_FG=${config.myhome.oomox.sel_fg}
          SPACING=${builtins.toString config.myhome.oomox.spacing}
          SPOTIFY_PROTO_BG=${config.myhome.oomox.spotify_proto_bg}
          SPOTIFY_PROTO_FG=${config.myhome.oomox.spotify_proto_fg}
          SPOTIFY_PROTO_SEL=${config.myhome.oomox.spotify_proto_sel}
          TERMINAL_ACCENT_COLOR=${config.myhome.oomox.terminal_accent_color}
          TERMINAL_BACKGROUND=${config.myhome.oomox.terminal_background}
          TERMINAL_BASE_TEMPLATE=${config.myhome.oomox.terminal_base_template}
          TERMINAL_COLOR0=${config.myhome.oomox.terminal_color0}
          TERMINAL_COLOR1=${config.myhome.oomox.terminal_color1}
          TERMINAL_COLOR10=${config.myhome.oomox.terminal_color10}
          TERMINAL_COLOR11=${config.myhome.oomox.terminal_color11}
          TERMINAL_COLOR12=${config.myhome.oomox.terminal_color12}
          TERMINAL_COLOR13=${config.myhome.oomox.terminal_color13}
          TERMINAL_COLOR14=${config.myhome.oomox.terminal_color14}
          TERMINAL_COLOR15=${config.myhome.oomox.terminal_color15}
          TERMINAL_COLOR2=${config.myhome.oomox.terminal_color2}
          TERMINAL_COLOR3=${config.myhome.oomox.terminal_color3}
          TERMINAL_COLOR4=${config.myhome.oomox.terminal_color4}
          TERMINAL_COLOR5=${config.myhome.oomox.terminal_color5}
          TERMINAL_COLOR6=${config.myhome.oomox.terminal_color6}
          TERMINAL_COLOR7=${config.myhome.oomox.terminal_color7}
          TERMINAL_COLOR8=${config.myhome.oomox.terminal_color8}
          TERMINAL_COLOR9=${config.myhome.oomox.terminal_color9}
          TERMINAL_FOREGROUND=${config.myhome.oomox.terminal_foreground}
          TERMINAL_THEME_AUTO_BGFG=${boolshow config.myhome.oomox.terminal_theme_auto_bgfg}
          TERMINAL_THEME_MODE=${config.myhome.oomox.terminal_theme_mode}
          THEME_STYLE=${config.myhome.oomox.theme_style}
          TXT_BG=${config.myhome.oomox.txt_bg}
          TXT_FG=${config.myhome.oomox.txt_fg}
          UNITY_DEFAULT_LAUNCHER_STYLE=${boolshow config.myhome.oomox.unity_default_launcher_style}
          WM_BORDER_FOCUS=${config.myhome.oomox.wm_border_focus}
          WM_BORDER_UNFOCUS=${config.myhome.oomox.wm_border_unfocus}
        '';

        theme = pkgs.stdenv.mkDerivation rec {
          name = "oomox-theme";
          src = pkgs.fetchFromGitHub {
            owner = "themix-project";
            repo = "oomox-gtk-theme";
            rev = "750d830298180571b119627214445f721f1078e2";
            hash = "sha256-/lffKZPP5IHOw+AKlEroVEF55qC6E6lD7UhL/l2s6GQ=";
          };

          buildPhase = "echo build phase";
          buildInputs = with pkgs; [
            glib
            gdk-pixbuf
            sassc
            gtk3
            gtk-engine-murrine
          ];

          installPhase = ''
            mkdir -p $out/share/themes

            echo args -o oomox -t $out/share/themes ${themeconfig}

            ./change_color.sh -o oomox -t $out/share/themes ${themeconfig}
          '';
        };
      in
      theme;
    # $out/share/themes directory to write to in package
    gtk.theme.name = "oomox";
    stylix.targets.gtk.enable = false;
  });
}
