{ src, stdenv, autoconf, automake, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "SDL2_ttf";
  inherit src;

  buildInputs = [ autoconf automake pspsdk ];

  configureFlags = [
    "--prefix=$(out)/psp"
    "--host=psp"
    "--with-sdl-prefix=${pspsdk}/psp"
    "--without-x"
  ];

  preConfigure = ''
    unset CC
    unset CXX
    export SDL_CFLAGS="-I${pspsdk}/psp/include/SDL2"
    export FT2_CONFIG="${pspsdk}/psp/bin/freetype-config"
    export CFLAGS="-I${pspsdk}/psp/include/SDL2 "
    export SDL_LIBS="-lSDL2"
    ./autogen.sh
    export LDFLAGS="-L${pspsdk}/lib -L${pspsdk}/psp/sdk/lib -L${pspsdk}/psp/lib -lc -lpspuser"
    export LIBS="-lc -lpspuser"
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
