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
              popd ;;
            "collect-garbage")
              nix-collect-garbage --delete-older-than 5d
              sudo nix-collect-garbage --delete-older-than 5d ;;
            "collect-garbage-all")
              nix-collect-garbage -d
              sudo nix-collect-garbage -d  ;;
            "update-button")
              kitty bash -c 'system update; fish' ;;
            "build-iso")
              pushd ~/dotfiles
              nix build .?submodules=1#nixosConfigurations.iso.config.system.build.isoImage
              popd
              ;;
            "deploy")
              pushd ~/dotfiles
              rsync -r --exclude=.git . nixos@rpi-home-1:~/dotfiles
              ssh nixos@rpi-home-1 'nixos-rebuild switch --flake "./dotfiles?submodules=1#rpi-home"'

              # git push rpi-home main
              # ssh nixos@rpi-home-1 'git -C ./dotfiles submodule update --recursive'
              # ssh nixos@rpi-home-1 'nixos-rebuild switch --flake "./dotfiles?submodules=1#rpi-home"'
              popd
            ;;
            *)

              echo "unknown command: $1"
              echo "valid commands: "
              echo "  home"
              echo "  system"
              echo "  update"
              echo "  collect-garbage"
              echo "  collect-garbage-all"
              echo "  build-iso";;
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
