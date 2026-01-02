{ stdenv, inputs }:
stdenv.mkDerivation {
  name = "clipb";
  src = "${inputs.clipb}";
  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins/
    cp -r rc/* $out/share/kak/autoload/plugins/
  '';
}
