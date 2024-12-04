{ standalone }:
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
    (import ./niri { inherit standalone; })
    # ./niri
    ./deway.nix
    ./swaync.nix
    ./desktop.nix
    ./flatpak.nix
    ./colors.nix
    ./dropbox.nix
    ./waybar.nix
    # ./oomox-gtk-theme.nix
  ];

  options.myhome.username = lib.mkOption {
    description = "username to use in home-manager";
    type = lib.types.str;
    default = "a";
  };

  config = {
    home = {
      username = config.myhome.username;
      homeDirectory = "/home/${config.myhome.username}";
    };

    nixpkgs.config.allowUnfree = true;

    home = {
      packages = with pkgs; [
        # always
        bc
        unzip
        git
        zoxide

        # system management script
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
            "build-iso")
              pushd ~/dotfiles
              nix build .?submodules=1#nixosConfigurations.iso.config.system.build.isoImage
              popd
              ;;
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

    home.stateVersion = "23.11";

    programs.home-manager.enable = true;
  };
}
