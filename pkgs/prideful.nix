{ pkgs , rustPlatform , fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
    version = "1.0";
    pname = "prideful";

    src = fetchFromGitHub {
        owner = "angelofallars";
        repo = "prideful";
        rev = "e60506c63218e9377a4286774c46fe0e33aefc56";
        hash = "";
    };

    cargoHash = "sha256-pY+ndJHK9ddaM9azxizZe2/PAHFWWbHuf0N3dopK7TM=";
}
