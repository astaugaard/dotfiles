{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib;
{
  options.myhome.waybar = {
    enable = mkOption {
      description = "enable waybar";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.waybar.enable {
    programs.waybar = {
      settings.mainbar = {
        # layer = "top";
        position = "top";
        margin-left = 5;
        margin-right = 5;
        margin-top = 5;
        height = 20;
        spacing = 10;
        mode = "dock";

        modules-left = [
          "custom/launcher"
          "wlr/taskbar"
        ];

        modules-right = [
          "group/bottom1"
          "group/bottom2"
        ];

        "group/power" = {
          orientation = "inherit";
          drawer = {
            transition-durration = 500;
            children-class = "not-power";
            transition-left-to-right = false;
          };
          modules = [
            "custom/power"
            "custom/quit"
            "custom/lock"
            "custom/reboot"
          ];
        };

        "group/bottom1" = {
          orientation = "inherit";
          modules = [
            "privacy"
            "idle_inhibitor"
            "pulseaudio"
          ];
        };

        "group/bottom2" = {
          orientation = "inherit";
          modules = [
            "clock"
            "tray"
            "group/power"
          ];
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "shutdown now";
        };

        "custom/quit" = {
          format = "󰈆";
          tooltip = false;
          on-click = "niri msg action quit";
        };

        "custom/lock" = {
          format = "󰍁";
          tooltip = "false";
          on-click = "swaylock";
        };

        "custom/reboot" = {
          format = "";
          tooltip = false;
          on-click = "shutdown -r now";
        };

        "custom/launcher" = {
          format = "";
          tooltip = false;
          on-click = "rofi -modi drun -show drun -show-icons";
        };

        "wlr/taskbar" = {
          sort-by-app-id = true;
          on-click = "activate";
          on-click-middle = "close";
          on-click-right = "minimize";
          icon-size = 25;
        };

        privacy = {
          icon-size = 25;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = false;
        };

        pulseaudio = {
          format = "{volume}%";
          format-muted = "󰖁";
          format-icons.default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          scroll-step = 1.0;
        };

        clock = {
          format = "{:%H:%M}";
        };

        tray = {
          icon-size = 25;
          spacing = 10;
        };
      };

      style = ''
        .background {
          background: rgba(0,0,0,0);
        }

        .module {
          padding-left: 10px;
          padding-right: 10px;
          font-size: 20px;
          color: #${config.lib.stylix.colors.base01}
        }

        .modules-left {
          padding-left:25px;
          padding-right:25px;
          border-radius: 25px;
          background-image: linear-gradient(0deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base09} );
        }

        #bottom1 {
          padding-left:25px;
          padding-right:25px;
          background-color: blue;
          border-radius: 25px;
          background-image: linear-gradient(0deg, #${config.lib.stylix.colors.base0A}, #${config.lib.stylix.colors.base0B} );
        }

        #bottom2 {
          padding-left:25px;
          padding-right:25px;
          background-color: blue;
          border-radius: 25px;
          background-image: linear-gradient(0deg, #${config.lib.stylix.colors.base0C}, #${config.lib.stylix.colors.base0D} );
        }
      '';

      systemd.enable = true;
      enable = true;
    };
    stylix.targets.waybar.enable = false;
  };
}
