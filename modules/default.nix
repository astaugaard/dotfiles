{pkgs, config, lib, ...}:
{
    imports = [
        ./decommon.nix
        ./devtools.nix
        ./dex11.nix
        ./kitty
        ./picom
        ./neofetch
        ./toys.nix
        ./rofi
        ./kak.nix
        ./xmonad
        ./fish
        ./dunst.nix
        ./sway
        ./deway.nix
    ];
}
