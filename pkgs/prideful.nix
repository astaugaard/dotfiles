{
  pkgs,
  rustPlatform,
  fetchFromGitHub,
  inputs,
}:
rustPlatform.buildRustPackage rec {
  version = "1.0";
  pname = "prideful";

  src = "${inputs.prideful}";

  cargoLock = {
    lockFile = "${inputs.prideful}/Cargo.lock";
  };
}
