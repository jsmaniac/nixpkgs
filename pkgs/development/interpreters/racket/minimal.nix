{ stdenv, fetchurl, makeFontsConf, makeWrapper
, cairo, coreutils, fontconfig, freefont_ttf
, glib, gmp, gtk2, libffi, libjpeg, libpng
, libtool, mpfr, openssl, pango, poppler
, readline, sqlite, libedit, mesa_glu
}:

let

  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  libPath = stdenv.lib.makeLibraryPath [
    cairo
    fontconfig
    glib
    gmp
    gtk2
    libjpeg
    libpng
    mpfr
    openssl
    pango
    poppler
    readline
    sqlite
    libedit
    mesa_glu
  ];

in

stdenv.mkDerivation rec {
  name = "racket-${version}";
  version = "6.8.0.2";

  src = fetchurl {
    url = "https://plt.eecs.northwestern.edu/snapshots/current/installers/min-racket-${version}-src-pre-built.tgz";
    sha256 = "13g78isqhhdgz8r4lqlvn331c157ir3l0yyrmxcvpjg11rmig3x8";
  };

  FONTCONFIG_FILE = fontsConf;
  LD_LIBRARY_PATH = libPath;
  NIX_LDFLAGS = "-lgcc_s";

  buildInputs = [ fontconfig libffi libtool makeWrapper sqlite ];

  preConfigure = ''
    find | grep module.c
    sed -i -e 's/if (\*all_simple_bindings \&\& env->genv->module->rn_stx) {/if (*all_simple_bindings \&\& env->genv->module->rn_stx \&\& rec[drec].comp) {/' ./src/racket/src/module.c
    substituteInPlace src/configure --replace /usr/bin/uname ${coreutils}/bin/uname
    mkdir src/build
    cd src/build
  '';

  configureFlags = [ "--enable-shared" "--enable-lt=${libtool}/bin/libtool"];

  #configureScript = "bash /tmp/aa.sh";
  configureScript = "../configure";

  enableParallelBuilding = false;

  postInstall = ''
    "$out/bin/raco" setup;
    for p in $(ls $out/bin/) ; do
      wrapProgram $out/bin/$p --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}";
    done
  '';

  meta = with stdenv.lib; {
    description = "A programmable programming language";
    longDescription = ''
      Racket is a full-spectrum programming language. It goes beyond
      Lisp and Scheme with dialects that support objects, types,
      laziness, and more. Racket enables programmers to link
      components written in different dialects, and it empowers
      programmers to create new, project-specific dialects. Racket's
      libraries support applications from web servers and databases to
      GUIs and charts.
    '';
    homepage = http://racket-lang.org/;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ kkallio henrytill ];
    platforms = platforms.linux;
  };
}
