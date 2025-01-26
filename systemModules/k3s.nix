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
    services.k3s.gracefulNodeShutdown.enable = true;
    services.k3s.extraFlags = toString [
      "--node-external-ip"
      "169.254.90.188"
      # "--debug" # Optionally add additional args to k3s
    ];

    services.k3s.images = [
      (pkgs.dockerTools.pullImage {
        imageName = "freshrss/freshrss";
        imageDigest = "sha256:e7897e90c1e0ab4a68cb643ff509dec4e3b85bbe42e2688ed9f95eb190bcb2b1";
        sha256 = "sha256-hUave5lq7EphE9OyjP8cwKZMKmQb9TColTeot844/58=";
        finalImageTag = "1.25.0";
      })
    ];

    services.k3s.manifests = {
      longhorn = {
        enable = true;
        target = "longhorn-chart.yaml";
        content = {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            annotations."helmcharts.cattle.io/managed-by" = "helm-controller";
            finalizers = [ "wrangler.cattle.io/on-helm-chart-remove" ];
            generation = 1;
            name = "longhorn-install";
            namespace = "default";
          };

          spec = {
            version = "v1.8.0";
            chart = "longhorn";
            repo = "https://charts.longhorn.io";
            failurePolicy = "abort";
            targetNamespace = "longhorn-system";
            createNamespace = true;
          };
        };
      };

      # freshrsspod = {
      #   enable = true;
      #   target = "freshrss-pod.yaml";
      #   content = {
      #     apiVersion = "v1";
      #     kind = "Pod";
      #     metadata = {
      #       name = "freshrss-pod";
      #       labels = {
      #         app = "freshrss";
      #       };
      #     };
      #     spec = {
      #       securityContext = {
      #         fsGroup = 2000;
      #       };
      #       containers = [
      #         {
      #           name = "freshrss";
      #           image = "freshrss/freshrss:1.25.0";
      #           ports = [
      #             {
      #               containerPort = 80;
      #             }
      #           ];
      #           volumeMounts = [
      #             {
      #               name = "volume";
      #               mountPath = "/data";
      #             }
      #           ];
      #           env = [
      #             {
      #               name = "DATA_PATH";
      #               value = "/data";
      #             }
      #           ];
      #         }
      #       ];

      #       volumes = [
      #         {
      #           name = "volume";
      #           persistentVolumeClaim.claimName = "freshrss-volume";
      #         }
      #       ];
      #     };

      #   };
      # };

      # freshrss-volume = {
      #   enable = true;
      #   target = "freshrss-volume.yaml";
      #   content = {
      #     apiVersion = "v1";
      #     kind = "PersistentVolumeClaim";
      #     metadata = {
      #       name = "freshrss-volume";
      #       labels = "freshrss";
      #     };

      #     spec = {
      #       storageClassName = "local-path";
      #       accessModes = [ "ReadWriteOnce" ];
      #       persistentVolumeReclaimPolicy = "Retain";
      #       resources.requests.storage = "2Gi";
      #     };
      #   };

      # };

      # freshrssservice = {
      #   enable = true;
      #   target = "freshrss-service.yaml";
      #   content = {
      #     apiVersion = "v1";
      #     kind = "Service";
      #     metadata = {
      #       name = "freshrss-service";
      #     };
      #     spec = {
      #       ports = [
      #         {
      #           port = 8080;
      #           targetPort = 80;
      #         }
      #       ];

      #       selector = {
      #         app = "freshrss";
      #       };

      #       type = "NodePort";

      #     };
      #   };
      # };
    };
  };
}
