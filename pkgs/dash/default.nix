{
  xorg,
  mkDerivation,
  base,
  lib,
  xmonad,
  xmonad-contrib,
}:
mkDerivation {
  pname = "DynamicDashboard";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base
    xmonad
    xmonad-contrib
    xorg.libX11
  ];
  testHaskellDepends = [ base ];
  homepage = "https://github.com/astaugaard/DynamicDashboard#readme";
  license = lib.licenses.bsd3;
}
