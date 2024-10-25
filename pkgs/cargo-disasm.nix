{ pkgs , rustPlatform , fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
    version = "1.0";
    pname = "cargo-disasm";

    src = fetchFromGitHub {
        owner = "ExPixel";
        repo = "cargo-disasm";
        rev = "86548e27c95200d860789824c6404f5382fc393b";
        hash = "";
    };

    cargoHash = "";
}
