{
  pkgs,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  version = "1.0";
  pname = "prideful";

  src = fetchFromGitHub {
    owner = "angelofallars";
    repo = "prideful";
    rev = "e60506c63218e9377a4286774c46fe0e33aefc56";
    hash = "sha256-3X0hhsGtRtULQYget3Lq9MBuLGgUaUcieKiyqOAJr54=";
  };

  cargoHash = "sha256-syaTG0bItVw0GvRjQkxaFzHmOZCZ6iGx4L6Ou7qtUTg=";
}
