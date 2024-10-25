self: super: {
    catsay = self.callPackage ./catsay.nix {};
    # greatVibes = self.callPackage ./googleFonts.nix {};
    reasymotion = self.callPackage ./reasymotion.nix {};

    prideful = self.callPackage ./prideful.nix {};

    cargo-disasm = self.callPackage ./cargo-disasm.nix {};

    haskellPackages = super.haskellPackages.override {
        overrides = self: super: {
            dynamicDashboard = self.callPackage ./dash {};
        };
    };
}
