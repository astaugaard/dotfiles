{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  ...
}:
with builtins;
with lib;
let
  myhelm = (
    with pkgs;
    wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    }
  );
  myhelmfile = pkgs.helmfile-wrapped.override {
    inherit (myhelm) pluginsDir;
  };
in
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
      # kubectl
      # myhelm
      # myhelmfile

      docker

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
      pkgs-unstable.clippy
      pkgs-unstable.cabal-install
      pkgs-unstable.rustfmt

      pkgs-unstable.typst
      pkgs-unstable.typst-live
      pkgs-unstable.tinymist

      # why3
      # creusot

      # coq
      # coqPackages.coqide

      # cargo-disasm # removed for now bc test not passing
    ];
  };
}
