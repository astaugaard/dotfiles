{ pkgs ? import <nixpkgs>}:
# let backgroundImage = pkgs.fetchpatch {url = "https://tools.suckless.org/slock/patches/background-image/slock-background-image-20220318-1c5a538.diff";
#                         sha256 = "sha256:3I8dBCn/fvV4FYIdpnsLvFREf807hiCa3jzjgT1bhY8=";
#                       };

#     dpms = pkgs.fetchpatch {url = "https://tools.suckless.org/slock/patches/dpms/slock-dpms-1.4.diff";
#                         sha256 = "sha256-hfe71OTpDbqOKhu/LY8gDMX6/c07B4sZ+mSLsbG6qtg="; # sha256-hfe71OTpDbqOKhu/LY8gDMX6/c07B4sZ+mSLsbG6qtg=
#                         # sha256-EClvEftx5o2efJPjI/OCOZd4l0+XGhKZ2g3p8y+DfT4=
#                        };

#     colorMessage = pkgs.fetchpatch {url = "https://tools.suckless.org/slock/patches/colormessage/slock-colormessage-20200210-35633d4.diff";
#                         sha256 = "sha256:vUnfVGJPYgy7YsminYB26+SbJ4ouVaegPPN58KIpGuw=";
#                      };

#     xresourcesP = pkgs.fetchpatch {url = "https://tools.suckless.org/slock/patches/xresources/slock-xresources-20191126-53e56c7.diff";
#                         sha256 = "sha256:EClvEftx5o2efJPjI/OCOZd4l0+XGhKZ2g3p8y+DfT4=";
#                        };
# in
pkgs.stdenv.mkDerivation rec {
  pname = "slock";
  version = "1.4";

  src = pkgs.fetchurl {
    url = "https://dl.suckless.org/tools/slock-${version}.tar.gz";
    sha256 = "0sif752303dg33f14k6pgwq2jp1hjyhqv6x4sy3sj281qvdljf5m";
  };

  patches = [./myConfigDiff];

  buildInputs = [ pkgs.xorg.xorgproto pkgs.xorg.libX11 pkgs.xorg.libXext pkgs.xorg.libXrandr pkgs.xorg.libXinerama pkgs.imlib2];

  installFlags = [ "PREFIX=$(out)" ];

  postPatch = "sed -i '/chmod u+s/d' Makefile";

  # preBuild = optionalString (conf != null) ''
  #   cp ${writeText "config.def.h" conf} config.def.h
  # '';

  makeFlags = [ "CC:=$(CC)" ];

  meta = {
    homepage = "https://tools.suckless.org/slock";
    description = "Simple X display locker";
    longDescription = ''
      Simple X display locker. This is the simplest X screen locker.
    '';
    license = pkgs.lib.licenses.mit;
    maintainers = with pkgs.maintainers; [ astsmtl ];
    platforms = pkgs.lib.platforms.linux;
  };
}
