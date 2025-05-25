{
  pkgs,
  rustPlatform,
  fetchgit,
}:
rustPlatform.buildRustPackage rec {
  version = "1.0";
  pname = "gtk-quick-launch";

  src = pkgs.fetchFromGitHub {
    owner = "astaugaard";
    repo = "quick-launch";
    rev = "c3b7d123c83efe88b08da9355e23a69fc639787e";
    hash = "sha256-57wXrW2UbWc+717XcRxw54ISOKdAOL5WotwMdztaNBo=";
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

  cargoHash = "sha256-jHd0xzc/9eCklPxeb4croGn84wGLCJaziKJDMQDq/LA=";
}
