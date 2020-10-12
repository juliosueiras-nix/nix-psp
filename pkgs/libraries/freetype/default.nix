{ src, stdenv, libtool, automake, autoconf, callPackage, fetchFromGitHub, pspsdk, ...
}:

stdenv.mkDerivation {
  name = "freetype";
  inherit src;

  buildInputs = [ libtool automake autoconf pspsdk ];

  configureFlags = [
    "--prefix=$(out)/psp"
    "--host=psp"
    "--enable-freetype-config"
    "--without-bzip2"
    "--without-png"
  ];

  preConfigure = ''
    unset CC
    export CC_BUILD="gcc"
    unset CXX
    ./autogen.sh
    export LDFLAGS="-L${pspsdk}/lib -L${pspsdk}/psp/sdk/lib -L${pspsdk}/psp/lib -lc -lpspuser"
    export LIBS="-lc -lpspuser"
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}

