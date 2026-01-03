{
  pkgs,
  config,
  lib,
  tools,
  ...
}:
{
  imports = [
    ./decommon.nix
    ./devtools.nix
    ./toys.nix
    ./rofi.nix
    ./kak.nix
    ./fish.nix
    ./kitty.nix
    ./niri
    ./deway.nix
    ./swaync.nix
    ./desktop.nix
    ./flatpak.nix
    ./colors.nix
    ./dropbox.nix
    ./waybar.nix
    ./makima.nix
  ];

  options = {
    myhome.username = lib.mkOption {
      description = "username to use in home-manager";
      type = lib.types.str;
      default = "a";
    };
  };

  config = {
    home = {
      username = config.myhome.username;
      homeDirectory = "/home/${config.myhome.username}";
    };

    home = {
      packages = with pkgs; [
        # always
        bc
        unzip
        git
        qrcp
        caligula
        trash-cli

        (tools.make_commands_script {
          inherit pkgs;
          options = {
            home = ''
              pushd ~/dotfiles
              home-manager switch --flake "."
              popd
            '';
            system = ''
              pushd ~/dotfiles
              sudo nixos-rebuild switch --flake "."
              popd
            '';
            update = ''
              pushd ~/dotfiles
              git pull origin main
              home-manager switch --flake "."
              sudo nixos-rebuild switch --flake "."
              nixos-rebuild switch --target-host "nixos@169.254.90.188" --use-remote-sudo --flake ".#rpi-home"
              ssh root@69.48.200.159 "apt-get update; apt-get upgrade"
              popd
            '';
            collect-garbage = ''
              nix-collect-garbage --delete-older-than 5d
              sudo nix-collect-garbage --delete-older-than 5d
            '';
            update-button = ''
              kitty bash -c 'system update; fish' &
              disown -a
            '';
            build-iso = ''
              pushd ~/dotfiles
              nix build .#nixosConfigurations.iso.config.system.build.isoImage
              popd
            '';
            deploy = ''
              pushd ~/dotfiles
              nixos-rebuild switch --target-host "nixos@169.254.90.188" --use-remote-sudo --flake ".#rpi-home"
              popd
            '';
          };
          name = "system";
        })
      ];

      sessionVariables.LS_COLORS = "di=36;40:ln=0";
    };

    xdg.enable = true;

    home.stateVersion = "23.11";

    programs.home-manager.enable = true;
  };
}
