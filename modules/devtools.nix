{pkgs, config, lib, ...}:
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
        cabal-install
        valgrind
        cargo
        rust-analyzer
        qmk
        libglvnd
        nodePackages.node2nix
        chez
        gmp.dev
        gnumake
        rustfmt
      ];
    };
}

