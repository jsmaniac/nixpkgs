{ stdenv, fetchurl, pkgconfig, xlibsWrapper, xorg, dbus, imlib2, freetype, gtk }:

let version = "0.7"; in
  stdenv.mkDerivation {
    name = "e16keyedit-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/enlightenment/e16keyedit-${version}.tar.gz";
      sha256 = "18h93hwhws1rird0zlg21dlhzv9217nwrx04xrdplprmlmfa76lg";
    };

    buildInputs = [pkgconfig imlib2 freetype gtk
      xorg.libX11 xorg.libXt xorg.libXext xorg.libXrender xorg.libXft ];

    meta = {
      description = "Standalone keybindings editor for enlightenment version 0.16";

      longDescription = ''
        Enlightenment is a window manager.  Enlightenment is a desktop
        shell.  Enlightenment is the building blocks to create
        beautiful applications.  Enlightenment, or simply e, is a
        group of people trying to make a new generation of software.
        
        This package contains the keybindings editor for enlightenment version 0.16.
      '';

      homepage = http://enlightenment.org/;

      license = "BSD-style";
    };
  }
