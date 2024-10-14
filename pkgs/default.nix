self: super: {
    catsay = self.callPackage ./catsay.nix {};
    # greatVibes = self.callPackage ./googleFonts.nix {};
    reasymotion = self.callPackage ./reasymotion.nix {};

    prideful = self.callPackage ./prideful.nix {};

    haskellPackages = super.haskellPackages.override {
        overrides = self: super: {
            dynamicDashboard = self.callPackage ./dash {};
        };
    };
}
