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
  options.mysystem.k3s = {
    enable = mkOption {
      description = "enable system tailscale";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.mysystem.k3s.enable {
    networking.firewall.allowedTCPPorts = [
      6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
      # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
      # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
    ];
    networking.firewall.allowedUDPPorts = [
      # 8472 # k3s, flannel: required if using multi-node for inter-node networking
    ];
    services.k3s.enable = true;
    services.k3s.role = "server";
    services.k3s.extraFlags = toString [
      # "--debug" # Optionally add additional args to k3s
    ];
  };
}
