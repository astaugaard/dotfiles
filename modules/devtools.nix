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
      # general c stuff (so most languages)
      pkg-config
      glib
      # valgrind
      gcc
      lld
      # qmk maybe in future
      # librsvg
      # libglvnd
      # gmp.dev

      # haskell
      # stack
      # ghc
      # haskell-language-server

      # misc
      # nodePackages.node2nix
      # chez
      # gnumake

      nixfmt-rfc-style

      # rust
      trunk
      pkgs-unstable.cargo
      pkgs-unstable.cargo-tarpaulin
      pkgs-unstable.rust-analyzer
      pkgs-unstable.cabal-install
      pkgs-unstable.rustfmt
      # cargo-disasm # removed for now bc test not passing
    ];
  };
}
