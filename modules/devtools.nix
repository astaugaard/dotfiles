{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  tools,
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

      (
        let
          rust-script = pkgs.writeShellScriptBin "start-rust" ''
            kitty --detach bash -c "niri msg action focus-column-left; bacon"
            kak
          '';
          typst-script = pkgs.writeShellScriptBin "start-typst" ''
            kitty --detach bash -c "niri msg action focus-column-left; typst-live $1"
            kak $1
          '';
        in

        tools.make_commands_script {
          inherit pkgs;
          options = {
            rust = ''
              if ! nix develop --command ${rust-script}/bin/start-rust; then
                ${rust-script}/bin/start-rust
              fi
            '';
            typst = ''
              if ! nix develop --command ${typst-script}/bin/start-typst $1; then
                ${typst-script}/bin/start-typst $1
              fi
            '';
            config = ''
              cd ~/dotfiles
              kitty --detach
              kak
            '';
          };
          name = "start";
        }
      )

      # (
      #   let
      #     rust-script = pkgs.writeShellScriptBin "start-rust" ''
      #       kitty --detach bash -c "niri msg action focus-column-left; bacon"
      #       kak
      #     '';
      #     typst-script = pkgs.writeShellScriptBin "start-typst" ''
      #       kitty --detach bash -c "niri msg action focus-column-left; typst-live $1"
      #       kak $1
      #     '';
      #   in
      #   pkgs.writeShellScriptBin "start" ''
      #     case $1 in
      #       "rust")
      #         if ! nix develop --command ${rust-script}/bin/start-rust; then
      #           ${rust-script}/bin/start-rust
      #         fi
      #         ;;
      #       "typst")
      #         shift
      #         if ! nix develop --command ${typst-script}/bin/start-typst $1; then
      #           ${typst-script}/bin/start-typst $1
      #         fi
      #         ;;
      #       "config")
      #         cd ~/dotfiles
      #         kitty --detach
      #         kak
      #         ;;
      #       *)
      #         echo "unknown command: $1"
      #         echo "valid commands: "
      #         echo "  rust"
      #         echo "  typst"
      #         echo "  config"
      #     esac
      #   ''
      # )

      # rust
      trunk
      pkgs-unstable.cargo
      pkgs-unstable.cargo-tarpaulin
      pkgs-unstable.rust-analyzer
      pkgs-unstable.clippy
      pkgs-unstable.cabal-install
      pkgs-unstable.rustfmt
      pkgs-unstable.bacon

      # typst
      pkgs-unstable.typst
      pkgs-unstable.typst-live
      pkgs-unstable.tinymist

      presenterm

      # why3
      # creusot

      # coq
      # coqPackages.coqide

      # cargo-disasm # removed for now bc test not passing
    ];
  };
}
