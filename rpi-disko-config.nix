# {
#   disko.devices = {
#     disk = {
#       main = {
#         device = "/dev/mmcblk1";
#         type = "disk";
#         content = {
#           type = "gpt";
#           partitions = {
#             boot = {
#               size = "1M";
#               type = "EF02"; # for grub MBR
#             };
#             # ESP = {
#             #   type = "EF00";
#             #   size = "500M";
#             #   content = {
#             #     type = "filesystem";
#             #     format = "vfat";
#             #     mount = "/boot";
#             #     mountOptions = [ "umask=0077" ];
#             #   };
#             # };
#             root = {
#               end = "-8G";
#               content = {
#                 type = "filesystem";
#                 format = "ext4";
#                 mountpoint = "/";
#                 mountOptions = [
#                   "defaults"
#                 ];
#               };
#               # bootable = true;
#             };
#             plainSwap = {
#               size = "100%";
#               content = {
#                 type = "swap";
#                 discardPolicy = "both";
#                 resumeDevice = true;
#               };
#             };
#           };
#         };
#       };
#     };
#   };
# }
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/mmcblk1";
        content = {
          type = "gpt";
          efiGptPartitionFirst = false;
          partitions = {
            TOW-BOOT-FI = {
              priority = 1;
              type = "EF00";
              size = "32M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = null;
              };
              hybrid = {
                mbrPartitionType = "0x0c";
                mbrBootableFlag = false;
              };
            };
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
