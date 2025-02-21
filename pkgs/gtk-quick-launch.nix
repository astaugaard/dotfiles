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
    rev = "72d9a9f3ed81c63054b7990e0e310f147abca23b";
    hash = "sha256-Ek3fAeq2bG1I/n7dHQXxaB+a8eWEM/Fsyc8WAXQkf9I=";
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

  cargoHash = "sha256-Pk8wIxPiyUS7Bb7JcV2VB0h+TJKlUQJp7e5hBnjc8sE=";
}
