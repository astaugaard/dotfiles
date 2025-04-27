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
        position = "top";
        margin-left = 5;
        margin-right = 5;
        margin-top = 0;
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
            "custom/sleep"
            "custom/reboot"
          ];
        };

        "group/bottom1" = {
          orientation = "inherit";
          modules = [
            "privacy"
            "idle_inhibitor"
            "pulseaudio"
            "custom/update"
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

        "custom/update" =
          let
            update_script = pkgs.writeShellScriptBin "since_last_update" ''
              #!/bin/bash

              MOD_TIME=`stat -c %Y /home/${config.myhome.username}/dotfiles/flake.lock`
              RIGHTNOW=`date +%s`
              HOW_LONG=`expr $RIGHTNOW - $MOD_TIME`
              NUM_DAYS=`expr $HOW_LONG / 86400`
              NUM_HOURS=`expr \( $HOW_LONG % 86400 \) / 3600`

              echo "$NUM_DAYS d + $NUM_HOURS h"
            '';
          in
          {
            format = "󰚰  {}";
            tooltip = false;
            on-click = "system update-button";
            exec = "${update_script}/bin/since_last_update";
            interval = 3600;
          };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "shutdown now";
        };

        "custom/sleep" = {
          format = "󰤄";
          tooltip = false;
          on-click = "systemctl hybrid-sleep";
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
          on-click = "rofi -show drun -terminal kitty";
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

        #custom-launcher {
            color: #${config.lib.stylix.colors.base08}
        }

        #idle_inhibitor {
            color: #${config.lib.stylix.colors.base09}
        }

        #pulseaudio {
            color: #${config.lib.stylix.colors.base0A}
        }

        #custom-update {
            color: #${config.lib.stylix.colors.base0B}
        }

        #clock {
            color: #${config.lib.stylix.colors.base0C}
        }

        #custom-power {
            color: #${config.lib.stylix.colors.base0D}
        }

        #custom-quit {
            color: #${config.lib.stylix.colors.base0E}
        }

        #custom-lock {
            color: #${config.lib.stylix.colors.base0F}
        }

        #custom-sleep {
            color: #${config.lib.stylix.colors.base05}
        }

        #custom-reboot {
            color: #${config.lib.stylix.colors.base08}
        }

        .module {
          padding-left: 10px;
          padding-right: 10px;
          font-size: 25px;
          color: #${config.lib.stylix.colors.base05};
        }

        .modules-left {
          padding-left:25px;
          padding-right:25px;
          border-bottom-left-radius: 25px;
          border-bottom-right-radius: 25px;
          background-color: #${config.lib.stylix.colors.base00};
        }

        #bottom1 {
          padding-left:25px;
          padding-right:25px;
          background-color: blue;
          border-bottom-left-radius: 25px;
          border-bottom-right-radius: 25px;
          background-color: #${config.lib.stylix.colors.base00};
        }

        #privacy-item {
            color: #${config.lib.stylix.colors.base05};
        }

        .popup {
            font-size: 20px;
        }

        #bottom2 {
          padding-left:25px;
          padding-right:25px;
          background-color: blue;
          border-bottom-left-radius: 25px;
          border-bottom-right-radius: 25px;
          background-color: #${config.lib.stylix.colors.base00};
        }
      '';

      systemd.enable = true;
      enable = true;
    };
    stylix.targets.waybar.enable = false;
  };
}
