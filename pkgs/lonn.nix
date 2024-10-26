{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "Loenn";
  version = "0.7.8";

  buildInputs = [
    pkgs.unzip
    pkgs.love
  ];

  src = (
    pkgs.fetchzip {
      url = "https://github.com/CelestialCartographers/Loenn/releases/download/v0.7.8/Loenn-v0.7.8-linux.zip";
      sha256 = "sha256-7tW9HNbQ0F15+7YblSL62tXSZFgLTMXVcDew81E/cs8=";
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
