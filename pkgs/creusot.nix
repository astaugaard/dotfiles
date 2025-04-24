{
  pkgs,
  rustPlatform,
  fetchgit,
  system,
}:
let
  toolchain = pkgs.rust-bin.selectLatestNightlyWith (
    toolchain:
    toolchain.default.override {
      extensions = [
        "rust-src"
        "rustc-dev"
        "llvm-tools-preview"
      ];
    }
  );
in
(pkgs.makeRustPlatform {
  cargo = toolchain;
  rustc = toolchain;
}).buildRustPackage
  rec {
    version = "0.4.0";
    pname = "creusot";

    src = pkgs.fetchFromGitHub {
      owner = "creusot-rs";
      repo = "creusot";
      rev = "7992ee4558cef02ad36ae42643c6002bce5cf48e";
      hash = "sha256-67ytVqIU4MPpUINOBehatmvVJvddARySfmBG7k9peVw=";
    };

    buildInputs = with pkgs; [ openssl ];

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    cargoHash = "sha256-WQJjEwN18ieG73RyNvFup9X4raG5EEn7lipX3vyO/4o=";
    useFetchCargoVendor = true;
  }
