{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "battlesnake";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "BattlesnakeOfficial";
    repo = "rules";
    rev = "v1.2.3";
    sha256 = "sha256-Gpcu1yMkHao4KOF3WtWrU0mxMAJ+AIlG3ZJ03uzM1Hk=";
  };

  vendorHash = "sha256-tGOxBhyOPwzguRZY4O2rLoOMaT3EyryjYcO2/2GnVIU=";
}
