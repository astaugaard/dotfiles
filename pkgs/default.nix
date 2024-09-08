self: super: {
    catsay = self.callPackage ./catsay.nix {};
    greatVibes = self.callPackage ./googleFonts.nix {};

    haskellPackages = super.haskellPackages.override {
        overrides = self: super: {
            dynamicDashboard = self.callPackage ./dash {};
        };
    };
}
