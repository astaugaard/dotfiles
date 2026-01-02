{ stdenv, inputs }:
stdenv.mkDerivation {
  name = "peneira";
  src = "${inputs.peneira}";
  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins/
    cp -r *.kak $out/share/kak/autoload/plugins/
    cp -r *.lua $out/share/kak/autoload/plugins/
  '';
}
