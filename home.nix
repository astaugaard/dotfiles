{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  ...
}:
{
  imports = [ (import ./modules { standalone = true; }) ];

  myhome.sway.enable = false;
  myhome.niri.enable = true;
  myhome.toys.enable = true;
  myhome.devtools.enable = true;
  myhome.kak.enable = true;
  myhome.flatpak.enable = true;
  myhome.dropbox.enable = true;
  myhome.desktop.enable = true;
}
