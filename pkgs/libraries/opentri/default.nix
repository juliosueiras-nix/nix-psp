{ stdenv, fetchurl, doxygen, pspsdk, ... }:

stdenv.mkDerivation {
  name = "opentri";

  src = fetchTarball {
    url =
      "https://github.com/SamRH/openTRI/archive/ec3f4418b8058fde3728c98f0f784ce06da7b108.tar.gz";
    sha256 = "1b2l0jdkrbk5qmg8rw86x36kwh13qqbjbqsshvaqvwhip8kiyayc";
  };

  buildInputs = [ pspsdk doxygen ];

  preConfigure = ''
    unset CC
    unset CXX
    export LDFLAGS="-L${pspsdk}/psp/lib -L${pspsdk}/psp/sdk/lib -lc -lpspuser"
    export LIBS="-lc -lpspuser"
    export CP=cp
    export MKDIR=mkdir 
    export DOXYGEN=doxygen 
    export PNG=1 
    export FT=1

    mkdir -p $out/psp/lib
    mkdir -p $out/nix-support
    echo "doc module-doc $out/psp/share/doc/openTri/html" >> $out/nix-support/hydra-build-products
    substituteInPlace Makefile --replace 'CFLAGS = -O3' 'CFLAGS = -O3 -I${pspsdk}/psp/include' --replace '$(PSPDIR)' '$(out)/psp'
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
