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
  options.myhome.toys = {
    enable = mkOption {
      description = "enable toys";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.toys.enable {
    home.packages = with pkgs; [
      hyfetch
      catsay
      fortune
      cbonsai
      cmatrix
      lolcat
      prideful
      sl
    ];

    programs.fastfetch.enable = true;
  };
}
