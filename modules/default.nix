{pkgs, config, lib, ...}: {
    imports = [
        ./neofetch
        ./picom
        ./devtools.nix
        ./toys.nix
        ./rofi
        ./kitty
        ./decommon.nix
        ./dex11.nix
        ./xmonad
    ];
}
