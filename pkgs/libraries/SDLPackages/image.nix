{ src, stdenv, autoconf, automake, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "SDL_image";
  inherit src;

  buildInputs = [ autoconf automake pspsdk ];

  configureFlags =
    [ "--prefix=$(out)/psp" "--host=psp" "--with-sdl-prefix=${pspsdk}/psp" ];

  preConfigure = ''
    unset CC
    unset CXX
    aclocal -I acinclude -I${pspsdk}/psp/share/aclocal
    automake --foreign --include-deps --add-missing --copy
    autoconf
    export LDFLAGS="-L${pspsdk}/lib -L${pspsdk}/psp/sdk/lib -L${pspsdk}/psp/lib -lc -lpspuser"
    export CFLAGS="-I${pspsdk}/psp/include "
    export LIBS="-lc -lpspuser"
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
