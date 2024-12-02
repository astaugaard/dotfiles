{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  ...
}:
{
  imports = [ (import ./modules { standalone = true; }) ];
  # imports = [ ./modules ];

  myhome.xmonad.enable = false;
  myhome.sway.enable = true;
  myhome.niri.enable = true;
  myhome.toys.enable = true;
  myhome.devtools.enable = true;
  myhome.kak.enable = true;
  myhome.flatpak.enable = true;
  myhome.dropbox.enable = true;
}
