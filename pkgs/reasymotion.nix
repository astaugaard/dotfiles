{
  pkgs,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  version = "1.0";
  pname = "reasymotion";

  src = fetchFromGitHub {
    owner = "astaugaard";
    repo = "reasymotion";
    rev = "aaffa008d0a82717deb133a8fdd1b16167bed75b";
    hash = "sha256-3KJ5dmpmRvJax1MOM4B82wApwcuB8OZY4RaHnkf6Bdk=";
  };

  cargoHash = "sha256-pY+ndJHK9ddaM9azxizZe2/PAHFWWbHuf0N3dopK7TM=";
}
