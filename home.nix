{ config, pkgs, lib, nix-colors, catppuccin,... }:
let
    tex =
        pkgs.texlive.combine {
            inherit (pkgs.texlive) scheme-tetex standalone preview;
        };
in
{
  imports = [
  	./modules
  	nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.catppuccin-macchiato;

  nixpkgs.overlays = [
      (import ./pkgs)
  ];

  nixpkgs.config.allowUnfree = true;

  myhome.xmonad.enable = true;
  myhome.sway.enable = true;
  myhome.toys.enable = true;
  myhome.devtools.enable = true;
  myhome.kak.enable = true;


  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
      username = "a";
      homeDirectory = "/home/a";

      packages = with pkgs; [
        # always
        alsa-utils
        bc
        unzip
        git
        maestral
        nix-index

        qemu
      ];

      sessionVariables = {
          GTK_THEME = "catppuccin";
          WLR_RENDERER = "vulkan";
      };
  };

  gtk.enable = true;

  gtk.catppuccin = {
      enable = true;
      flavor = "macchiato";
      accent = "mauve";
      size = "standard";
      tweaks = ["normal"];
  };

  gtk.iconTheme = {
      name = "BeautyLine";
      package = pkgs.beauty-line-icon-theme;
  };

  gtk.gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
  };

  gtk.gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
  };

  qt.style.package = pkgs.catppuccin-qt5ct;

  programs.password-store.enable = true;

  xdg.enable = true;

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = ["librewolf.desktop"];
    "x-scheme-handler/https" = ["librewolf.desktop"];
  };

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
}
