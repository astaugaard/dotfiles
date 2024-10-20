{pkgs, config, lib, ...}:
with builtins;
with lib;
{
    options.myhome.sway = {
        enable = lib.mkOption {
            description = "enable sway";
            type = lib.types.bool;
            default = false;
        };
    };

    config = mkIf config.myhome.sway.enable {
        wayland.windowManager.sway.enable = true;
        wayland.windowManager.sway.checkConfig = false;
        wayland.windowManager.sway.xwayland = true;
        wayland.windowManager.sway.swaynag.enable = true;

        home.packages = [
            pkgs.pulseaudio
        ];

        wayland.windowManager.sway.extraConfig = "
        output * bg ~/backgrounds/butterfly.png fill
        xwayland enable
        ";


        wayland.windowManager.sway.extraSessionCommands =
            ''
            export SDL_VIDEODRIVER=wayland
            # needs qt5.qtwayland in systemPackages
            export QT_QPA_PLATFORM=wayland
            export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
            # Fix for some Java AWT applications (e.g. Android Studio),
            # use this if they aren't displayed properly:
            export _JAVA_AWT_WM_NONREPARENTING=1

            export GTK_USE_PORTAL="0"
            export WLR_RENDERER="vulkan"
            '';

        wayland.windowManager.sway.config = {
            down = "t";
            up = "n";
            left = "h";
            right = "s";
            focus.mouseWarping = true;
            gaps = {
                horizontal = 0;
                vertical = 0;
                inner = 10;
                smartGaps = true;
                smartBorders = "on";
            };

            bars = [];

            modifier = "Mod4";

            keybindings =
              let modifier = config.wayland.windowManager.sway.config.modifier;
                  up = config.wayland.windowManager.sway.config.up;
                  down = config.wayland.windowManager.sway.config.down;
                  left = config.wayland.windowManager.sway.config.left;
                  right = config.wayland.windowManager.sway.config.right;
              in {
                "${modifier}+p" = "exec rofi -theme launcher -modi drun -show drun -show-icons";
                "${modifier}+Shift+Return" = "exec kitty";
                "${modifier}+Shift+c" = "exec flatpak run org.flameshot.Flameshot gui";
                "${modifier}+Shift+o" = "exec swaync-client -t -sw";

                "${modifier}+Shift+w" = "kill";
                "${modifier}+Shift+q" = "exec exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
                "${modifier}+Shift+l" = "exec swaylock --image ~/Dropbox/lock.png";

                "${modifier}+${up}" = "focus up";
                "${modifier}+Shift+${up}" = "move up";
                "${modifier}+${down}" = "focus down";
                "${modifier}+Shift+${down}" = "move down";
                "${modifier}+${left}" = "focus left";
                "${modifier}+Shift+${left}" = "move left";
                "${modifier}+${right}" = "focus right";
                "${modifier}+Shift+${right}" = "move right";
                "${modifier}+a" = "focus parent";

                "${modifier}+1" = "workspace number 1";
                "${modifier}+Shift+1" = "move container to workspace number 1";
                "${modifier}+2" = "workspace number 2";
                "${modifier}+Shift+2" = "move container to workspace number 2";
                "${modifier}+3" = "workspace number 3";
                "${modifier}+Shift+3" = "move container to workspace number 3";
                "${modifier}+4" = "workspace number 4";
                "${modifier}+Shift+4" = "move container to workspace number 4";
                "${modifier}+5" = "workspace number 5";
                "${modifier}+Shift+5" = "move container to workspace number 5";
                "${modifier}+6" = "workspace number 6";
                "${modifier}+Shift+6" = "move container to workspace number 6";
                "${modifier}+7" = "workspace number 7";
                "${modifier}+Shift+7" = "move container to workspace number 7";
                "${modifier}+8" = "workspace number 8";
                "${modifier}+Shift+8" = "move container to workspace number 8";
                "${modifier}+9" = "workspace number 9";
                "${modifier}+Shift+9" = "move container to workspace number 9";
                "${modifier}+0" = "workspace number 10";
                "${modifier}+Shift+0" = "move container to workspace number 10";

                "${modifier}+b" = "splith";
                "${modifier}+v" = "splitv";

                "${modifier}+d" = "floating toggle";
                "${modifier}+Shift+d" = "mode_toggle";

                "${modifier}+Shift+r" = "mode \"resize\"";

                "XF86AudioMute" = "exec pactl set-sink-mute \@DEFAULT_SINK@ toggle";
                "XF86AudioLowerVolume" = "exec pactl set-sink-volume \@DEFAULT_SINK@ -5%";
                "XF86AudioRaiseVolume" = "exec pactl set-sink-volume \@DEFAULT_SINK@ +5%";
                "XF86AudioMicMute" = "exec pactl set-source-mute \@DEFAULT_SOURCE@ toggle";
              };

            startup = [
                { command = "maestral start"; }
                { command = "systemctl --user import-environment"; }
                # { command = "swaync"; }
                # { command = "dbus-update-activation-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK I3SOCK XCURSOR_SIZE XCURSOR_THEME"; }
            ];

            

            terminal = "kitty";

            window.titlebar = false;

            colors = {
                focused = {
                    border = "#${config.colorScheme.palette.base07}";
                    background = "#${config.colorScheme.palette.base07}";
                    childBorder = "#${config.colorScheme.palette.base07}";
                    indicator = "#${config.colorScheme.palette.base07}";
                    text = "#${config.colorScheme.palette.base07}";
                };

                unfocused = {
                    border = "#${config.colorScheme.palette.base01}";
                    background = "#${config.colorScheme.palette.base01}";
                    childBorder = "#${config.colorScheme.palette.base01}";
                    indicator = "#000000";
                    text = "#000000";
                };
            };
        };

    	myhome.decommon.enable = true;
    	myhome.deway.enable = true;
    };
}

