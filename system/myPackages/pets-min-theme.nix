{
	stdenv
}:
stdenv.mkDerivation {
    name = "grub-pets-min-theme";
    src = ./grubtheme;
    installPhase = ''
	mkdir -p $out/grub/theme/
	cp -r * $out/grub/theme
    '';
}
