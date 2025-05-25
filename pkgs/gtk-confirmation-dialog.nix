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
    rev = "938d877f50ed5640698682cc6f130185f34bce81";
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

  cargoHash = "sha256-OC7fIE1lzRN6r3+xUMxgUZnEW8DT/YI/5Px28czSeSE=";
}
