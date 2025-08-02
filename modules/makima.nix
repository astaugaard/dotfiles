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
  options.myhome.makima = {
    enable = mkOption {
      description = "enable makima";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.makima.enable {

    # home.packages = with pkgs; [
    #   maliit-keyboard
    #   maliit-framework
    # ];

    xdg.configFile."makima/Microsoft X-Box One pad.toml" = {
      text = ''
        [remap]
        BTN_TR = ["BTN_RIGHT"] #RB
        BTN_TL = ["BTN_LEFT"] #LB

        BTN_DPAD_UP = ["KEY_UP"] #directional pad up
        BTN_DPAD_RIGHT = ["KEY_RIGHT"] #directional pad right
        BTN_DPAD_DOWN = ["KEY_DOWN"] #directional pad down
        BTN_DPAD_LEFT = ["KEY_LEFT"] #directional pad left

        BTN_EAST = ["KEY_ENTER"]
        BTN_START = [ "KEY_LEFTMETA", "KEY_O" ]
        BTN_SELECT = [ "KEY_LEFTMETA", "KEY_A" ]
        BTN_MODE = [ "KEY_ESC" ]

        BTN_SOUTH-BTN_NORTH = ["KEY_LEFTMETA", "KEY_LEFTSHIFT", "KEY_W"]

        BTN_SOUTH-BTN_EAST = ["KEY_LEFTMETA", "KEY_LEFTSHIFT", "KEY_F"]

        # [commands]
        # RSTICK_LEFT = ["foot sh -c 'pacman -Q | wc -l && sleep 1 && neofetch' && sleep 5"] #right analog stick left
        # RSTICK_RIGHT = ["firefox", "discord"] #right analog stick right

        [movements]
        BTN_SOUTH-BTN_DPAD_UP = "CURSOR_UP"
        BTN_SOUTH-BTN_DPAD_RIGHT = "CURSOR_RIGHT"
        BTN_SOUTH-BTN_DPAD_DOWN = "CURSOR_DOWN"
        BTN_SOUTH-BTN_DPAD_LEFT = "CURSOR_LEFT"

        [settings]
        LSTICK_SENSITIVITY = "16" #sensitivity when scrolling or moving cursor, lower value is higher sensitivity, minimum 1
        RSTICK_SENSITIVITY = "6" #sensitivity when scrolling or moving cursor, lower value is higher sensitivity, minimum 1
        LSTICK = "cursor" #cursor, scroll, bind or disabled
        RSTICK = "scroll" #cursor, scroll, bind or disabled

        CURSOR_SPEED = "6"
        LSTICK_DEADZONE = "20" #integer between 0 and 128, bigger number is wider deadzone, default 5
        RSTICK_DEADZONE = "20" #integer between 0 and 128, bigger number is wider deadzone, default 5
        16_BIT_AXIS = "true" #necessary for Xbox controllers and Switch joycons, use false for other controllers
      '';

      onChange = ''
        ${pkgs.procps}/bin/pkill -u $USER -USR2 makima || true
      '';
    };

    systemd.user.services.makima = {
      Unit = {
        Description = "makima service";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.makima}/bin/makima";
        Restart = "on-failure";
      };
    };
  };
}
