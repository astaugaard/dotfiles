{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "catsay";
  version = "0.3.2";

  buildInputs = [ pkgs.ruby pkgs.bash];

  src = (pkgs.fetchgit {
      url = "https://github.com/audy/catsay.git";
      sha256 = "sha256-UEqV+CVOIjUfShKJM6o4F8J7zZkTVIQCJ797GdIPWVw=";
      rev = "843a547523af7d702f2f9d1feed5d20ec0619f3d";
  });

  buildPhase = ''
  '';
  installPhase = ''
    mkdir -p $out/share/catsay
    mkdir -p $out/bin
    cp -r * $out/share/catsay
    bin=$out/bin/catsay

    cat > $bin <<EOF
#!/usr/bin/env bash
exec $out/share/catsay/bin/catsay "\$@"
EOF
    chmod +x $bin
  '';
}
