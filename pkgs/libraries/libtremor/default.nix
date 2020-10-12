{ src, stdenv, libtool, automake, autoconf, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "libtremor";
  inherit src;

  buildInputs = [ pspsdk libtool automake autoconf ];

  configurePhase = ''
    unset CC
    unset CXX
    export LDFLAGS="-L${pspsdk}/psp/sdk/lib"
    export LIBS="-lc -lpspuser"
    ./autogen.sh --host=psp --prefix="$out/psp"
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
