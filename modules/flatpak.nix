{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  ...
}:
with lib;
{
  options.myhome.flatpak = {
    enable = mkOption {
      description = "enable shared parts of the \"de\"";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.flatpak.enable {
    home.packages = with pkgs; [
      gnome-software
      flatpak
    ];

    services.flatpak.enable = true;

    services.flatpak.remotes = lib.mkOptionDefault [
      {
        name = "wpilib-origin";
        location = "file:///home/a/Dropbox/wpilibflatpak/repo";
      }
    ];

    services.flatpak.packages = [
      "com.bitwarden.desktop"
      "com.github.tchx84.Flatseal"
      "com.github.unrud.VideoDownloader"
      "com.obsproject.Studio"
      "com.spotify.Client"
      "dev.vencord.Vesktop"
      "io.bassi.Amberol"
      "io.github.celluloid_player.Celluloid"
      "io.github.flattool.Warehouse"
      "io.github.wxmaxima_developers.wxMaxima"
      "net.lutris.Lutris"
      "org.blender.Blender"
      "org.gimp.GIMP"
      "org.gnome.Evince"
      "org.gnome.eog"
      "org.inkscape.Inkscape"
      "org.libreoffice.LibreOffice"
      "org.mozilla.Thunderbird"
      "org.torproject.torbrowser-launcher"
      "org.prismlauncher.PrismLauncher"
      "in.cinny.Cinny"
      "com.github.johnfactotum.Foliate"
      "io.github.everestapi.Olympus"
      "org.signal.Signal"
      "net.ankiweb.Anki"
    ];

    services.flatpak.uninstallUnmanaged = true;
    services.flatpak.update.onActivation = true;

    xdg.systemDirs.data = [
      "/usr/share"
      "/var/lib/flatpak/exports/share"
      "~/.local/share/flatpak/exports/share"
    ];
  };
}
