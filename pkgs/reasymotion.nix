{ pkgs , rustPlatform , fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
    version = "1.0";
    pname = "reasymotion";

    src = fetchFromGitHub {
        owner = "astaugaard";
        repo = "reasymotion";
        rev = "5009e8e8b5f803c3f3075c05f92a888e06ea19b4";
        hash = "sha256-dnPGY2YH9hFiz+VJAZr682s64hoGeL25SxbbuxS9ypA=";
    };

    cargoHash = "sha256-pY+ndJHK9ddaM9azxizZe2/PAHFWWbHuf0N3dopK7TM=";
}
