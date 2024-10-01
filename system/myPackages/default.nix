{ pkgs,
  ...
}:
let allpkgs = pkgs // mypkgs;
    callPackage = path: overides:
    	let f = import path;
    	in pkgs.lib.customisation.makeOverridable f ((builtins.intersectAttrs (builtins.functionArgs f) allpkgs) // overides);
    mypkgs = with pkgs; {
	plymouth-vortex = callPackage ./plymouth-vortex.nix { };
	grub-pets-min-theme = callPackage ./pets-min-theme.nix { };
    };
in mypkgs
