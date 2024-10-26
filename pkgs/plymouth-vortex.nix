{
  fetchFromGitHub,
  fetchurl,
  stdenv,
}:
let
  image = fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/white.png";
    sha256 = "sha256-0Ni0KWk8QlhfXIPXyRUo8566a4VYHbMcAD90g5QvpF0=";
  };
in
stdenv.mkDerivation rec {
  name = "plymouth-vortex";
  patches = [ ./vortextheme.patch ];
  src = fetchFromGitHub {
    owner = "emanuele-scarsella";
    repo = "vortex-ubuntu-plymouth-theme";
    rev = "2314eb4a146ac98610a91a42d783799df24d8dda";
    sha256 = "sha256-BVYgkjA95e9RWeq6myRmWf/xmmAJi8WrV9M4uQEPaHk=";
  };
  img = image;
  installPhase = ''
    	export themeDir="$out/share/plymouth/themes/vortex"
    	substituteAllInPlace vortex-ubuntu/vortex-ubuntu.grub
    	substituteAllInPlace vortex-ubuntu/vortex-ubuntu.script
    	substituteAll vortex-ubuntu/vortex-ubuntu.plymouth vortex-ubuntu/vortex.plymouth
    	mkdir -p $out/share/plymouth/themes/
    	mv vortex-ubuntu $out/share/plymouth/themes/vortex
    	cp $img $out/share/plymouth/themes/vortex/logo.png
  '';
}
