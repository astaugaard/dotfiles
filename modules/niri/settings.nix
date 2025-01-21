{
  config,
  pkgs,
  lib,
  ...
}:
{
  input.keyboard.xkb = {
    layout = "us";
  };

  binds = with config.lib.niri.actions; {
    "Mod+Shift+Slash".action = show-hotkey-overlay;
    "Mod+Shift+Return".action = spawn "kitty";
    "Mod+P".action = spawn "rofi" "-show" "drun" "-terminal" "kitty";
    "Super+Shift+C".action = screenshot;
    "Super+Shift+O".action = spawn "swaync-client" "-t" "-sw";
    "Super+Shift+L".action = spawn "swaylock" "--image" "${config.programs.swaylock.settings.image}";

    "Mod+R".action = switch-preset-column-width;
    "Mod+Shift+R".action = switch-preset-window-height;
    "Mod+Ctrl+R".action = reset-window-height;
    "Mod+F".action = maximize-column;
    "Mod+Shift+F".action = fullscreen-window;
    "Mod+C".action =
      spawn "rofi" "-show" "calc" "-modi" "calc" "-modi" "emoji" "-no-persist-history" "-calc-command"
        "echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy";

    "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
    "XF86AudioRaiseVolume".allow-when-locked = true;

    "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
    "XF86AudioLowerVolume".allow-when-locked = true;

    "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
    "XF86AudioMute".allow-when-locked = true;

    "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
    "XF86AudioMicMute".allow-when-locked = true;

    "Mod+Shift+W".action = close-window;

    "Mod+H".action = focus-column-left;
    "Mod+T".action = focus-window-down;
    "Mod+N".action = focus-window-up;
    "Mod+S".action = focus-column-right;

    "Mod+Shift+H".action = move-column-left;
    "Mod+Shift+T".action = move-window-down;
    "Mod+Shift+N".action = move-window-up;
    "Mod+Shift+S".action = move-column-right;

    "Mod+Home".action = focus-column-first;
    "Mod+End".action = focus-column-last;
    "Mod+Ctrl+Home".action = move-column-to-first;
    "Mod+Ctrl+End".action = move-column-to-last;

    "Mod+J".action = focus-workspace-down;
    "Mod+K".action = focus-workspace-up;
    "Mod+Shift+J".action = move-column-to-workspace-down;
    "Mod+Shift+K".action = move-column-to-workspace-up;

    "Mod+WheelScrollDown".action = focus-workspace-down;
    "Mod+WheelScrollDown".cooldown-ms = 150;

    "Mod+WheelScrollUp".action = focus-workspace-up;
    "Mod+WheelScrollUp".cooldown-ms = 150;

    "Mod+Ctrl+WheelScrollDown".action = move-column-to-workspace-down;
    "Mod+Ctrl+WheelScrollDown".cooldown-ms = 150;

    "Mod+Ctrl+WheelScrollUp".action = move-column-to-workspace-up;
    "Mod+Ctrl+WheelScrollUp".cooldown-ms = 150;

    "Mod+WheelScrollRight".action = focus-column-right;
    "Mod+WheelScrollLeft".action = focus-column-left;
    "Mod+Ctrl+WheelScrollRight".action = move-column-right;
    "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

    "Mod+Shift+WheelScrollDown".action = focus-column-right;
    "Mod+Shift+WheelScrollUp".action = focus-column-left;
    "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
    "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

    "Mod+1".action = focus-workspace 1;
    "Mod+2".action = focus-workspace 2;
    "Mod+3".action = focus-workspace 3;
    "Mod+4".action = focus-workspace 4;
    "Mod+5".action = focus-workspace 5;
    "Mod+6".action = focus-workspace 6;
    "Mod+7".action = focus-workspace 7;
    "Mod+8".action = focus-workspace 8;
    "Mod+9".action = focus-workspace 9;
    "Mod+Ctrl+1".action = move-column-to-workspace 1;
    "Mod+Ctrl+2".action = move-column-to-workspace 2;
    "Mod+Ctrl+3".action = move-column-to-workspace 3;
    "Mod+Ctrl+4".action = move-column-to-workspace 4;
    "Mod+Ctrl+5".action = move-column-to-workspace 5;
    "Mod+Ctrl+6".action = move-column-to-workspace 6;
    "Mod+Ctrl+7".action = move-column-to-workspace 7;
    "Mod+Ctrl+8".action = move-column-to-workspace 8;
    "Mod+Ctrl+9".action = move-column-to-workspace 9;

    "Mod+Comma".action = consume-window-into-column;
    "Mod+Period".action = expel-window-from-column;

    "Mod+BracketLeft".action = consume-or-expel-window-left;
    "Mod+BracketRight".action = consume-or-expel-window-right;

    "Mod+Minus".action = set-column-width "-10%";
    "Mod+Equal".action = set-column-width "+10%";

    "Mod+Shift+Minus".action = set-window-height "-10%";
    "Mod+Shift+Equal".action = set-window-height "+10%";

    "Print".action = screenshot;
    "Ctrl+Print".action = screenshot-screen;
    "Alt+Print".action = screenshot-window;

    "Mod+Shift+Q".action = quit;

    "Mod+Shift+P".action = power-off-monitors;

    "Mod+V".action = switch-focus-between-floating-and-tiling;
    "Mod+Shift+V".action = toggle-window-floating;
  };

  screenshot-path = "~/Dropbox/Screenshots/Screenshot %Y-%m-%d at %H:%M:%S.png";
  prefer-no-csd = true;
  spawn-at-startup = [
    (
      let
        background_file = pkgs.substituteAll {
          src = ./set_bg.fish;
          background_image = config.stylix.image;
        };
      in
      {
        command = [
          "${pkgs.fish}/bin/fish"
          "${background_file}"
        ];
      }
    )
    { command = [ "swaync" ]; }
    {
      command = [
        "systemctl"
        "start"
        "--user"
        "swayidle.service"
      ];
    }
    { command = [ "${pkgs.xwayland-satellite-unstable}/bin/xwayland-satellite" ]; }
    {
      command = [
        "dbus-update-activation-environment"
        "DISPLAY"
        "WAYLAND_DISPLAY"
      ];
    }

  ];

  input.focus-follows-mouse.enable = true;
  input.focus-follows-mouse.max-scroll-amount = "25%";
  input.warp-mouse-to-focus = true;

  window-rules = [
    {
      geometry-corner-radius = {
        bottom-left = 20.0;
        bottom-right = 20.0;
        top-left = 20.0;
        top-right = 20.0;
      };
      clip-to-geometry = true;
    }
    {
      matches = [
        { app-id = "^Bitwarden$"; }
        { app-id = "^vesktop$"; }
      ];
      block-out-from = "screen-capture";
    }
  ];

  layer-rules = [
    {
      matches = [
        { namespace = "swaync-notification-window"; }
        { namespace = "swaync-control-center"; }
      ];
      block-out-from = "screen-capture";
    }
  ];

  layout = {
    focus-ring = {
      enable = true;
      width = 2;
      active.color = "#${config.lib.stylix.colors.base07}";
      inactive.color = "#${config.lib.stylix.colors.base01}";
    };

    always-center-single-column = true;

    default-column-width = {
      proportion = 0.5;
    };

    gaps = 10;

    preset-column-widths = [
      { proportion = 0.333333333333; }
      { proportion = 0.5; }
      { proportion = 0.666666666666; }
    ];
  };

  cursor.size = 12;

  environment = {
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    GTK_USE_PORTAL = "0";
    WLR_RENDERER = "vulkan";
    DISPLAY = ":0";
  };
}
