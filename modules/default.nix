{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./decommon.nix
    ./devtools.nix
    ./dex11.nix
    ./picom
    ./toys.nix
    ./rofi.nix
    ./kak.nix
    ./xmonad
    ./fish.nix
    ./dunst.nix
    ./sway
    ./kitty.nix
    ./niri
    ./deway.nix
    ./swaync.nix
    ./desktop.nix
    ./flatpak.nix
    ./colors.nix
    # ./oomox-gtk-theme.nix
  ];
}
