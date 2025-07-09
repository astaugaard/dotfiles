inputs: self: super: {
  reasymotion = self.callPackage ./reasymotion.nix { inherit inputs; };

  prideful = self.callPackage ./prideful.nix { inherit inputs; };

  grub-pets-min-theme = self.callPackage ./pets-min-theme.nix { };

  gtk-quick-launch = self.callPackage ./gtk-quick-launch.nix { inherit inputs; };

  gtk-confirmation-dialog = self.callPackage ./gtk-confirmation-dialog.nix { inherit inputs; };

  display-image = self.callPackage ./display-image.nix { inherit inputs; };
}
