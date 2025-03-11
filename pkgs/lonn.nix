{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "Loenn";
  version = "0.9.0";

  buildInputs = [
    pkgs.unzip
    pkgs.love
  ];

  src = (
    pkgs.fetchzip {
      url = "https://github.com/CelestialCartographers/Loenn/releases/download/v0.9.0/Loenn-v0.9.0-linux.zip";
      sha256 = "sha256-FhPmm73QrNbqQiBmL7gzFY7DqtHzXJC0A1sKzUBiuYI=";
      stripRoot = false;
    }
  );

  buildPhase = '''';
  installPhase = ''
        bin=$out/bin/loenn

        mkdir $out
        mkdir $out/bin
        mkdir $out/share
        mkdir $out/share/loenn

        cp Lönn.love $out/share/loenn
        cp nfd.so $out/share/loenn
        cp nfd_zenity.so $out/share/loenn


        cat > $bin <<EOF
    #!/usr/bin/env bash
    cd $out/share/loenn
    ${pkgs.love}/bin/love Lönn.love
    EOF

        chmod +x $bin
  '';
}
