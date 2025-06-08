{
  pkgs,
  rustPlatform,
  fetchFromGitHub,
  inputs,
}:
rustPlatform.buildRustPackage rec {
  version = "1.0";
  pname = "reasymotion";

  src = "${inputs.reasymotion}";

  cargoLock = {
    lockFile = "${inputs.reasymotion}/Cargo.lock";
  };
}
