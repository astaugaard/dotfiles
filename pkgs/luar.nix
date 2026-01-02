{ stdenv, inputs }:
stdenv.mkDerivation {
  name = "luar";
  src = "${inputs.luar}";
  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins/
    cp -r *.kak $out/share/kak/autoload/plugins/
    cp -r *.lua $out/share/kak/autoload/plugins/
    cp -r luar.fnl $out/share/kak/autoload/plugins/
  '';
}
