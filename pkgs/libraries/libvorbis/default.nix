{ stdenv, libtool, automake, autoconf, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "libvorbis";

  src = "${fetchFromGitHub {
    repo = "psp-ports";
    owner = "pspdev";
    rev = "8804b97c955a156e75f1b552b8a5aae9713f674f";
    sha256 = "x09wM/AfeYgKoTRmxsr7iEG84VLzP2DCksAeHVWRCh0=";
  }}/libvorbis";

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
