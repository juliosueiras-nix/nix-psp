{ stdenv, libtool, automake, autoconf, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "libtremor";

  src = "${fetchFromGitHub {
    repo = "psp-ports";
    owner = "pspdev";
    rev = "8804b97c955a156e75f1b552b8a5aae9713f674f";
    sha256 = "x09wM/AfeYgKoTRmxsr7iEG84VLzP2DCksAeHVWRCh0=";
  }}/libTremor";

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
