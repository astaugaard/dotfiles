# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

# let mypkgs = import ./myPackages pkgs;
# in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko.nix
  ];

  disko.devices.disk.main.device = "/dev/nvme0";

  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostName = "nixos";
  time.timeZone = "America/New_York";

  mysystem.enablegc = true;
  mysystem.flatpak.enable = true;
  # mysystem.tailscale.enable = true;
  mysystem.niri = true;
  mysystem.sway = false;
  mysystem.user = "a";
  mysystem.userdescription = "astaugaard";
  mysystem.wpasupplicant.enable = true;
  mysystem.virt = true;
  mysystem.ssh.enable = true;
  mysystem.aarch-binfmt = true;

  mysystem.grub = true;
  mysystem.systemd-boot = false;
  mysystem.steam = true;
}
