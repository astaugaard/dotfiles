self: super: {
  catsay = self.callPackage ./catsay.nix { };
  # greatVibes = self.callPackage ./googleFonts.nix {};
  reasymotion = self.callPackage ./reasymotion.nix { };

  # loenn = self.callPackage ./lonn.nix { };

  prideful = self.callPackage ./prideful.nix { };

  cargo-disasm = self.callPackage ./cargo-disasm.nix { };

  grub-pets-min-theme = self.callPackage ./pets-min-theme.nix { };

  nixos-plymouth-vortex = self.callPackage ./plymouth-vortex.nix.nix { };

  battlesnake = self.callPackage ./battlesnake.nix { };

  gtk-quick-launch = self.callPackage ./gtk-quick-launch.nix { };

  gtk-confirmation-dialog = self.callPackage ./gtk-confirmation-dialog.nix { };

  haskellPackages = super.haskellPackages.override {
    overrides = self: super: { dynamicDashboard = self.callPackage ./dash { }; };
  };
}
