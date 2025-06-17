{
  pkgs,
  rustPlatform,
  fetchgit,
  inputs,
}:
rustPlatform.buildRustPackage rec {
  version = "1.0";
  pname = "egui-greeter";

  src = "${inputs.egui-greeter}";

  buildInputs = with pkgs; [
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    libGL
    libxkbcommon
    xorg.libXi
    xorg.libxcb
    libxkbcommon
    vulkan-loader
    wayland
  ];

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  fixupPhase = ''
    patchelf --set-rpath ${builtins.toString (pkgs.lib.makeLibraryPath buildInputs)} $out/bin/egui-greeter
  '';

  cargoLock = {
    lockFile = "${inputs.egui-greeter}/Cargo.lock";
  };
}
