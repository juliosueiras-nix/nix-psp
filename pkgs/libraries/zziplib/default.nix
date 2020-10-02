{ stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "zziplib";

  src = "${fetchFromGitHub {
    repo = "psp-ports";
    owner = "pspdev";
    rev = "8804b97c955a156e75f1b552b8a5aae9713f674f";
    sha256 = "x09wM/AfeYgKoTRmxsr7iEG84VLzP2DCksAeHVWRCh0=";
  }}/zziplib";

  buildInputs = [ pspsdk ];

  preConfigure = ''
    unset CC
    unset CXX
    export LDFLAGS="-L${pspsdk}/psp/lib -L${pspsdk}/psp/lib -L${pspsdk}/psp/sdk/lib -lc -lpspuser"
    export CFLAGS="-I${pspsdk}/psp/include -I${pspsdk}/psp/sdk/include"
    export LIBS="-L${pspsdk}/psp/lib -lc -lpspuser -lz"
  '';

  configureFlags = [
    "--prefix=$(out)/psp"
    "--host=psp"
  ];

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
