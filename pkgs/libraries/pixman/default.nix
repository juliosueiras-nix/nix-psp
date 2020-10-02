{ stdenv, fetchurl, perl, pspsdk, ... }:

let
  PIXMAN_VERSION = "0.24.4";
in stdenv.mkDerivation {
  name = "pixman";

  src = fetchurl {
    url = "http://cairographics.org/releases/pixman-${PIXMAN_VERSION}.tar.gz";
    sha256 = "/qeGnCukH0n74ck4I5D/ZxrGKt1E3F8pE05h0PF5YN4=";
  };

  buildInputs = [ pspsdk perl ];

  patchPhase = let
    configSub = (fetchurl {
      url = "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/config.sub";
      sha256 = "TzlDC6/3Rb6aJRjVPZLAYSophSbiDaslnN8PYtYEias=";
    });
  in ''
    cp ${configSub} ./config.sub
  '';

  preConfigure = ''
    unset CC
    unset CXX
    export LDFLAGS="-L${pspsdk}/psp/lib -L${pspsdk}/psp/sdk/lib -lc -lpspuser"
    export LIBS="-lc -lpspuser"
    export PNG_CFLAGS="-I${pspsdk}/psp/include"
    export PNG_LIBS="-L${pspsdk}/psp/lib -lpng -lz"
  '';

  configureFlags = [
    "--prefix=$(out)/psp"
    "--host=psp" 
  ];

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
