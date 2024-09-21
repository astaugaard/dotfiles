self: super: {
    catsay = self.callPackage ./catsay.nix {};
    # greatVibes = self.callPackage ./googleFonts.nix {};
    reasymotion = self.callPackage ./reasymotion.nix {};

    haskellPackages = super.haskellPackages.override {
        overrides = self: super: {
            dynamicDashboard = self.callPackage ./dash {};
        };
    };
}
