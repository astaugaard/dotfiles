{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  ...
}:
with builtins;
with lib;
{
  options.myhome.kak = {
    enable = mkOption {
      description = "enable kakoune";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.kak.enable {
    home.packages = with pkgs; [
      reasymotion
      kakoune
      kakoune-lsp
      lua
      fd
    ];
    xdg.configFile."kak".source = ./kak;
    home.sessionVariables.EDITOR = "kak";
  };
}
