{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  ...
}:
{
  imports = [ ./modules ];

  nixpkgs.config.allowUnfree = true;

  myhome.xmonad.enable = false;
  myhome.sway.enable = true;
  myhome.niri.enable = true;
  myhome.toys.enable = true;
  myhome.devtools.enable = true;
  myhome.kak.enable = true;
  myhome.flatpak.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "a";
    homeDirectory = "/home/a";

    packages = with pkgs; [
      # always
      bc
      unzip
      git
      zoxide

      (pkgs.writeShellScriptBin "system" ''
        case $1 in
          "home") 
            pushd ~/dotfiles
            home-manager switch --flake ".?submodules=1"
            popd ;;
          "system")
            pushd ~/dotfiles
            sudo nixos-rebuild switch --flake ".?submodules=1"
            popd ;;
          "update")
            pushd ~/dotfiles
            nix flake update
            home-manager switch --flake ".?submodules=1"
            sudo nixos-rebuild switch --flake ".?submodules=1"
            ${if config.myhome.flatpak.enable then "flatpak update -y" else ""}
            popd ;;
          "collect-garbage")
            nix-collect-garbage --delete-older-than 5d
            sudo nix-collect-garbage --delete-older-than 5d
            ${if config.myhome.flatpak.enable then "flatpak uninstall - -unused " else ""};;
          "collect-garbage-all")
            nix-collect-garbage -d
            sudo nix-collect-garbage -d 
            ${if config.myhome.flatpak.enable then "flatpak uninstall - -unused " else ""};;
          *)
            echo "unknown command: $1"
            echo "valid commands: "
            echo "  home"
            echo "  system"
            echo "  update"
            echo "  collect-garbage"
            echo "  collect-garbage-all" ;;

        esac
      '')

    ];

    sessionVariables.LS_COLORS = "di=36;40:ln=0";
  };

  xdg.enable = true;

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
