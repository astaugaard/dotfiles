{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  ...
}:
with builtins;
with lib;
{
  options.myhome.devtools = {
    enable = mkOption {
      description = "enable toys";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.devtools.enable {
    home.packages = with pkgs; [
      pkg-config
      glib
      librsvg
      stack
      gcc
      ghc
      haskell-language-server
      pkgs-unstable.cabal-install
      valgrind
      pkgs-unstable.cargo
      pkgs-unstable.rust-analyzer
      # cargo-disasm # removed for now bc test not passing
      qmk
      libglvnd
      nodePackages.node2nix
      chez
      gmp.dev
      gnumake
      pkgs-unstable.rustfmt
      lld
      nixfmt-rfc-style
      trunk
    ];
  };
}
