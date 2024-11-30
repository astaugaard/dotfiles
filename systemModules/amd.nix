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
  options.mysystem = {
    amd = mkOption {
      description = "amd stuff that is need for newer-ish gpus";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.mysystem.amd {
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
