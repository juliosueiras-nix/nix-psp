{ stdenv, fetchurl, pspsdk, ... }:

let
  EXPAT_VERSION = "2.1.0";
in stdenv.mkDerivation {
  name = "expat";

  src = fetchurl {
    url = "http://sourceforge.net/projects/expat/files/expat/${EXPAT_VERSION}/expat-${EXPAT_VERSION}.tar.gz";
    sha256 = "gjcFRy+BbfIcj2qgJt0WKygIBoOLtVs0MrD7H8yn64Y=";
  };

  buildInputs = [ pspsdk ];

  preConfigure = ''
    unset CC
    unset CXX
    export LDFLAGS="-L${pspsdk}/psp/lib -L${pspsdk}/psp/sdk/lib -lc -lpspuser"
    export LIBS="-lc -lpspuser"
  '';

  configureFlags = [
    "--prefix=$(out)/psp"
    "--host=psp" 
  ];

  patchPhase = let
    configSub = (fetchurl {
      url = "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/config.sub";
      sha256 = "TzlDC6/3Rb6aJRjVPZLAYSophSbiDaslnN8PYtYEias=";
    });
  in ''
    cp ${configSub} ./config.sub
    cp ${configSub} ./conftools/config.sub
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
