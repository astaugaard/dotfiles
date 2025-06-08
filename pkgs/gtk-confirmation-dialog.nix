{
  pkgs,
  rustPlatform,
  fetchgit,
  inputs,
}:
rustPlatform.buildRustPackage rec {
  version = "1.0";
  pname = "gtk-confirmation-dialog";

  src = "${inputs.gtk-confirmation-dialog}";

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
    lockFile = "${inputs.gtk-confirmation-dialog}/Cargo.lock";
  };
}
