{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib;
{
  options.myhome.xmonad = {
    enable = lib.mkOption {
      description = "enable xmonad";
      type = lib.types.bool;
      default = true;
    };
  };

  config = mkIf config.myhome.xmonad.enable {
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [ haskellPackages.dynamicDashboard ];
      config = pkgs.substituteAll {
        src = ./config.hs;
        normalBorderColor = "#${config.colorScheme.palette.base01}";
        activeBorderColor = "#${config.colorScheme.palette.base07}";
      };
    };
    myhome.decommon.enable = true;
    myhome.dex11.enable = true;
  };
}
