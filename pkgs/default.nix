self: super: {
  catsay = self.callPackage ./catsay.nix { };
  # greatVibes = self.callPackage ./googleFonts.nix {};
  reasymotion = self.callPackage ./reasymotion.nix { };

  prideful = self.callPackage ./prideful.nix { };

  cargo-disasm = self.callPackage ./cargo-disasm.nix { };

  grub-pets-min-theme = self.callPackage ./pets-min-theme.nix { };

  nixos-plymouth-vortex = self.callPackage ./plymouth-vortex.nix.nix { };

  haskellPackages = super.haskellPackages.override {
    overrides = self: super: { dynamicDashboard = self.callPackage ./dash { }; };
  };
}
