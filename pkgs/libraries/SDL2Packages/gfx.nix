{ stdenv, autoconf, automake, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "SDL2_gfx";

  src = fetchFromGitHub {
    repo = "SDL_gfx";
    owner = "pspdev";
    rev = "SDL2_gfx-psp";
    sha256 = "4L/SC/i13Wl+EyUKI6ALYPFTRXzYmtYn0jhRp+2sUQM=";
  };

  buildInputs = [ autoconf automake pspsdk ];

  configureFlags = [
    "--prefix=$(out)/psp"
    "--host=psp"
    "--with-sdl-prefix=${pspsdk}/psp"
    "--disable-mmx"
  ];

  preConfigure = ''
    unset CC
    unset CXX
    export SDL_CFLAGS="-I${pspsdk}/psp/include/SDL2"
    export CFLAGS="-I${pspsdk}/psp/include/SDL2"
    export SDL_LIBS="-lSDL2"
    ./autogen.sh
    export LDFLAGS="-L${pspsdk}/lib -L${pspsdk}/psp/sdk/lib -L${pspsdk}/psp/lib -lc -lpspuser"
    export LIBS="-lc -lpspuser"
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
