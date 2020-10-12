{ src, stdenv, libtool, automake, autoconf, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "libvorbis";
  inherit src;

  buildInputs = [ pspsdk libtool automake autoconf ];

  configurePhase = ''
    unset CC
    unset CXX
    export LDFLAGS="$LDFLAGS -L${pspsdk}/psp/sdk/lib -L${pspsdk}/psp/lib"
    export CFLAGS="$CFLAGS -I${pspsdk}/psp/include"
    export LIBS="$LIBS -lc -lpspuser"
    ./autogen.sh --host=psp --prefix="$out/psp"
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
