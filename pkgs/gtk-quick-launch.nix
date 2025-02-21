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
    repo = "quick-launch";
    rev = "b080d75024f260146b5ad036d9e72105f3062986";
    hash = "sha256-w66icsZroAM+f/qdZnEtby822/8Tr9//uhakNB9Z/0I=";
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

  cargoHash = "sha256-WpllHeB0zhkCqfYgnR4YMP8DfG91OFluMbSGBScTpPA=";
}
