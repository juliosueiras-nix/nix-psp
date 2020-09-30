{ stdenv, libtool, automake, autoconf, callPackage, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "freetype";

  src = fetchFromGitHub {
    repo = "freetype2";
    owner = "pspdev";
    rev = "freetype2-psp";
    sha256 = "p6phT3SYRlsnbhauXV/haL2WY5ZyU0FXZhEAJcSe7Oo=";
  };

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

