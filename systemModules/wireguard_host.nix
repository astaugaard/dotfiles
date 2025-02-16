{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  ...
}:
with builtins;
with lib;
{
  options.mysystem.wireguard-host = {
    enable = mkOption {
      description = "enable system tailscale";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.mysystem.wireguard-host.enable {
    networking.firewall = {
      allowedUDPPorts = [
        5553
      ];
    };

    networking.wireguard = {
      enable = true;

      # environment.systemPackages = with pkgs; [
      #   iptables
      # ];

      interfaces.wg0 = {
        ips = [ "100.64.0.2/24" ];
        listenPort = 5553;

        # publickey: j3Dhp1rNowkQ/ZlJi8HaYnCcjil6NZWaYMaozAPELTw=
        privateKeyFile = config.sops.secrets."wg-private-rpi".path;

        peers = [
          {
            publicKey = "4OwrGOuxS93ICxQwJN+el4vyunkGlsaVOqHsXZNWnDM=";
            endpoint = "69.48.200.159:5180";
            allowedIPs = [ "100.64.0.0/24" ];
            persistentKeepalive = 25;
          }
        ];

      };
    };
    sops.secrets."wg-private-rpi" = { };
  };
}
