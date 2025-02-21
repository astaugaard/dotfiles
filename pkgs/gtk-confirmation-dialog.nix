{
  pkgs,
  rustPlatform,
  fetchgit,
}:
rustPlatform.buildRustPackage rec {
  version = "1.0";
  pname = "gtk-confirmation-dialog";

  src = pkgs.fetchFromGitHub {
    owner = "astaugaard";
    repo = "gtk-confirmation-dialog";
    rev = "10dc2e4d75cdd77848027b77407b1f5556cab570";
    hash = "sha256-q63ULK/0IgiwcOwubsVbCPJKWi4RADuo9sBeSPFNQxo=";
  };

  buildInputs = with pkgs; [
    cairo
    gtk4
    atk
    glib
    gobject-introspection
    pango
    gdk-pixbuf
    graphene
    gtk4-layer-shell
  ];

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  cargoHash = "sha256-KpIM1BphtM6beAnmAaaV85u9Y0+/6shjs9zXFf9MH6Q=";
}
