{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
{
  imports = [ ./flatpak.nix ];

  options.mysystem = {
    enablegc = mkOption {
      description = "enable garbage collection of nix store";
      type = lib.types.bool;
      default = false;
    };
    firewall = mkOption {
      description = "enable firewall";
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    nix = {
      # package = pkgs.lix;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      gc = {
        automatic = config.mysystem.enablegc;
        dates = "weekly";
        options = "--delete-older-than 5d";
      };
    };

    networking.firewall.enable = config.mysystem.firewall;

    networking.firewall = {
      allowedTCPPorts = [
        17500
        17599
        17600
        17601
        17602
        17603
        17604
        17605
        17606
        17607
        17608
        17609
        53317 # for localsend
      ];
      allowedUDPPorts = [
        17500
        53317
      ];
    };
  };
}
