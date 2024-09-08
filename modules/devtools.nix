{pkgs, pkgs-unstable, config, lib, ...}:
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
        pkgs-unstable.cargo
        pkgs-unstable.rust-analyzer
        qmk
        libglvnd
        nodePackages.node2nix
      ];
    };
}

