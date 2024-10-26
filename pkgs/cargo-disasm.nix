{
  pkgs,
  rustPlatform,
  fetchgit,
}:
rustPlatform.buildRustPackage rec {
  version = "1.0";
  pname = "cargo-disasm";

  src = fetchgit {
    url = "https://github.com/ExPixel/cargo-disasm.git";
    fetchSubmodules = true;
    rev = "86548e27c95200d860789824c6404f5382fc393b";
    hash = "sha256-HbsglAQEoxjDKF/dNvKpB8UfbNsYFJ9briLn65Nf3bA=";
  };

  cargoHash = "sha256-rNbSInvcl2Z4JmXs9iF8r1Eo7b4bDWNV5hYKtRPWd3g=";
}
