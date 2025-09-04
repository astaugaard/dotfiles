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
  options.mysystem = {
    bluetooth = mkOption {
      description = "bluetooth stuff";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.mysystem.bluetooth {
    environment.systemPackages = with pkgs; [
      bluetui
    ];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          # Shows battery charge of connected devices on supported
          # Bluetooth adapters. Defaults to 'false'.
          Experimental = true;
        };
        Policy = {
          # Enable all controllers when they are found. This includes
          # adapters present on start as well as adapters that are plugged
          # in later on. Defaults to 'true'.
          AutoEnable = true;
        };
      };
    };
  };
}
