{ stdenv, fetchgit, cmake, fltk13
, zlib, libjpeg, libpng, cairo, freetype
, json_c, fontconfig, gtkmm3, pangomm, mesa, libspnav
, pcre, libpthreadstubs, libXdmcp, libX11, libxkbcommon, epoxy, at_spi2_core, dbus, gettext
, pkgconfig
}:

stdenv.mkDerivation {
  name = "solvespace-3.0";
  src = fetchgit {
    url = "https://github.com/solvespace/solvespace.git";
          #https://github.com/jwesthues/solvespace.git";
    sha256 = "1n3p6zic1w5fvw85af8pl5mhmfqai67pd0dfr1qanbanydv4xh9c";
    rev = "911c67b";
    leaveDotGit = true;
  };

  # e587d0e fails with undefined reference errors if make is called
  # twice. Ugly workaround: Build while installing.
  #dontBuild = true;
  enableParallelBuilding = false;

  buildInputs = [
    cmake
    fltk13
    zlib
    libjpeg
    libpng
    cairo
    freetype
    json_c
    fontconfig
    gtkmm3
    pangomm
    mesa
    libspnav
    pcre
    libpthreadstubs
    libXdmcp
    libX11
    pkgconfig
    libxkbcommon
    epoxy
    at_spi2_core
    dbus
    gettext
  ];

  NIX_CFLAGS_COMPILE = [
  "-I${pangomm}/lib/pangomm-1.4/include"
  ];

  meta = {
    description = "A parametric 3d CAD program";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://solvespace.com;
  };
}
