{
  pkgs,
  rustPlatform,
  fetchgit,
  inputs,
}:
rustPlatform.buildRustPackage rec {
  version = "1.0";
  pname = "display-image";

  src = "${inputs.display-image}";

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

  cargoLock = {
    lockFile = "${inputs.display-image}/Cargo.lock";
  };
}
