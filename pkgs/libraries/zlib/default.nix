{ stdenv, fetchurl, pspsdk, ... }:

let
  ZLIB_VERSION = "1.2.8";
in stdenv.mkDerivation {
  name = "zlib";

  src = fetchurl {
    url = "http://sourceforge.net/projects/libpng/files/zlib/${ZLIB_VERSION}/zlib-${ZLIB_VERSION}.tar.gz";
    sha256 = "NmWMt2ilTB1N7EPDEWwn7Yk+iLAuz8tE8hZvnAt/Kg0=";
  };

  buildInputs = [ pspsdk ];

  PSPDIR_OUT = "$(out)/psp";

  preBuild = ''
    unset CC
    unset CXX
    export LDFLAGS="-L${pspsdk}/psp/lib -L${pspsdk}/psp/sdk/lib -lc -lpspuser"
    mkdir -p $out/psp/{include,lib}

    for file in $(find -name Makefile); do
      substituteInPlace $file --replace '$(PSPDIR)' '$(PSPDIR_OUT)'
    done
  '';

  patches = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/zlib-${ZLIB_VERSION}-PSP.patch";
      sha256 = "spYFcyZzbbuqduof+uQB8IXskPbohN9SOB+PGdv5/30=";
    })
  ];

  dontConfigure = true;
  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
