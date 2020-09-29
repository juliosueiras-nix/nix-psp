{ stdenv, pspirkeyb, autoconf, gcc, libtool, fetchurl, pspsdk, ... }:

let
  SDL_VERSION = "1.2.15";
in stdenv.mkDerivation {
  name = "SDL";

  src = fetchurl {
    url = "http://www.libsdl.org/release/SDL-${SDL_VERSION}.tar.gz";
    sha256 = "1tMWp5Pl40gVXw3ZO5eXmJM/uYqh7evMEIgp1kdKrQA=";
  };

  buildInputs = [ libtool autoconf pspsdk gcc ];

  PSPSDK = "${pspsdk}/psp/sdk";
  PSPDEV = "${pspsdk}";

  configureFlags = [
    "--enable-pspirkeyb"
    "--host=psp"
  ];

  preConfigure = ''
    unset CC
    unset CXX
    cat acinclude/* >aclocal.m4
    autoconf
    export LDFLAGS="-L${pspsdk}/lib -L${pspsdk}/psp/sdk/lib -L${pspsdk}/psp/lib -lc -lpspuser"
    export CFLAGS="-I${pspirkeyb}/include"
    export LIBS="-lc -lpspuser"
  '';

  patches = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/pspdev/psplibraries/2bd5631f2d9154a26dc09bd07ca979f8685c1d29/patches/SDL-${SDL_VERSION}-PSP.patch";
      sha256 = "yXwNuyqfOFvNnlYxSMGbiGY4UERr4T1Vs6or1tH+Cn0=";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/pspdev/psplibraries/2bd5631f2d9154a26dc09bd07ca979f8685c1d29/patches/SDL_glfuncs.h.patch";
      sha256 = "mmOVuGYrByuL+B0U+AI1hHVh5UrD9IxxtlCOIgiItU8=";
    })
  ];

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}


