{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "Great Vibes";
  version = "1.0.0";

  buildInputs = [ pkgs.unzip ];

  src = (
    pkgs.fetchgit {
      url = "https://github.com/google/fonts.git";
      sparseCheckout = [ "ofl/greatvibes" ];
      sha256 = "sha256-oBwcKXaI0Y/0mSrv3n8KJ17BkR0oyTMP1cpes5OYEK8=";
    }
  );

  buildPhase = '''';
  installPhase = ''
    mkdir -p $out/share/fonts/truetype/Great\ Vibes/
    mv ofl/greatvibes/GreatVibes-Regular.ttf $out/share/fonts/truetype/Great\ Vibes/GreatVibes-Regular.ttf
  '';
}
