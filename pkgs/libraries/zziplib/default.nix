{ src, stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "zziplib";
  inherit src;

  buildInputs = [ pspsdk ];

  preConfigure = ''
    unset CC
    unset CXX
    export LDFLAGS="$LDFLAGS -L${pspsdk}/psp/lib -L${pspsdk}/psp/sdk/lib -lc -lpspuser"
    export CFLAGS="$CFLAGS -I${pspsdk}/psp/include -I${pspsdk}/psp/sdk/include -O2"
    export LIBS="$LIBS -lc -lpspuser"
  '';

  postConfigure = ''
    substituteInPlace mipsallegrexel-psp-elf/config.h --replace "#define HAVE_DIRENT_H 1" ""

    substituteInPlace mipsallegrexel-psp-elf/zzip/_config.h \
    --replace "#define ZZIP_HAVE_DIRENT_H  1" ""
  '';

  configureFlags = [ "--prefix=$(out)/psp" "--host=psp" ];

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
