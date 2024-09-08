{ pkgs }:
# currently broken
pkgs.stdenv.mkDerivation rec {
  pname = "garmin IQ SDK";
  version = "4.1.7";

  buildInputs = [ pkgs.unzip ];

  src = (pkgs.fetchurl {
      url = "https://developer.garmin.com/downloads/connect-iq/sdk-manager/connectiq-sdk-manager-linux.zip";
      sha256 = "sha256-jlHhZwEZZcRO0Qi+Ahz7yp6JvAPOHU4p7d6bLCV+HJo=";
  });

  sourceRoot = ".";

  buildPhase = ''
  '';
  installPhase = ''
    mkdir $out
    mv * $out
  '';
}
