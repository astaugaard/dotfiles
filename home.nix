{ config, pkgs, lib, pkgs-unstable,... }:
let
    tex =
        pkgs.texlive.combine {
            inherit (pkgs.texlive) scheme-tetex standalone preview;
        };
    # unstable = import <nixos-unstable> {config = {allowUnfree = true; }; };
in
{
  imports = [
  	./xmonad/xmonad.nix
  ];

  nixpkgs.overlays = [
      (import ./pkgs)
  ];


  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
      username = "a";
      homeDirectory = "/home/a";

      packages = with pkgs; [
        dmenu
        # firefox
        pywal
        pkg-config
        rofi
        kak-lsp
        alsa-utils
        picom
        neofetch
        fish
        wmctrl
        eww
        nitrogen
        lxappearance
        sassc
        glib
        xdotool
        neofetch
        libnotify
        beauty-line-icon-theme
        dunst
        librsvg
        # gimp
        # grapejuice
        pass
        stack
        # discord
        # spotify
        xclip
        gnupg
        gcc
        pinentry-gtk2
        unzip
        ghc
        haskell-language-server
        nautilus
        bc
        tcpdump
        greatVibes
        # qbittorrent
        # wireshark
        # mySlock
        # dolphin-emu
        # shutter
        qemu
        # inkscape
        i3lock
        cabal-install
        galculator
        xorg.xclock
        # tex
        # anki
        # gdlauncher
        git
        valgrind
        scrot
        catsay
        fortune
        qmk
        # musescore
        pkgs-unstable.cargo
        pkgs-unstable.rust-analyzer
        libglvnd
        maestral
        maestral-gui
        nix-index
        # thunderbird
        ventoy
        hyfetch
        nodePackages.node2nix
        # tor-browser
        # prismlauncher
        gnome-software
        librewolf
        flatpak
      ];
  };

  programs.password-store.enable = true;
  # services.gpg-agent = {
    #  enable = true;
    #  pinentryFlavor = "curses";
    #  pinentryPackage = pkgs.pinentry-curses;
#  };

  xdg.enable = true;
  # xdg.configHome = "~/.config";

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = ["librewolf.desktop"];
    "x-scheme-handler/https" = ["librewolf.desktop"];
  };

  # xdg.configFile."eww".source = ./eww;
  xdg.configFile."rofi".source = ./rofi;
  xdg.configFile."wal".source = ./wal;
  xdg.configFile."kitty".source = ./kitty;
  xdg.configFile."picom".source = ./picom;
  xdg.configFile."neofetch".source = ./neofetch;

  xdg.systemDirs.data = ["/usr/share" "/var/lib/flatpak/exports/share" "~/.local/share/flatpak/exports/share"];

  # This value determines the Home Manager release that you
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  #systemctl --user import-environment PATH
  # systemctl --user restart xdg-desktop-portal.service
}
