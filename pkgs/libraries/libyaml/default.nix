{ stdenv, fetchurl, pspsdk, ... }:

let LIBYAML_VERSION = "0.1.4";
in stdenv.mkDerivation {
  name = "libyaml";

  src = fetchurl {
    url = "http://pyyaml.org/download/libyaml/yaml-${LIBYAML_VERSION}.tar.gz";
    sha256 = "e/gVVK5astm2l32jmOp4lyLg23W4a//a605m2WHeajc=";
  };

  buildInputs = [ pspsdk ];

  patchPhase = let
    configSub = (fetchurl {
      url =
        "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/config.sub";
      sha256 = "TzlDC6/3Rb6aJRjVPZLAYSophSbiDaslnN8PYtYEias=";
    });
  in ''
    cp ${configSub} ./config/config.sub
  '';

  preConfigure = ''
    unset CC
    unset CXX
    export LDFLAGS="-L${pspsdk}/psp/lib -L${pspsdk}/psp/sdk/lib -lc -lpspuser"
    export LIBS="-lc -lpspuser"
  '';

  configureFlags = [ "--prefix=$(out)/psp" "--host=psp" ];

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
