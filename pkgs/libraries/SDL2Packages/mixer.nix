{ stdenv, autoconf, automake, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "SDL2_mixer";

  src = fetchFromGitHub {
    repo = "SDL_mixer";
    owner = "pspdev";
    rev = "SDL2_mixer-psp";
    sha256 = "W+wLg4piO6ZfZEwQtf8CjhUGBBqHNr2gcM39IEkKBhk=";
  };

  buildInputs = [ autoconf automake pspsdk ];

  configureFlags = [
    "--prefix=$(out)/psp"
    "--host=psp"
    "--with-sdl-prefix=${pspsdk}/psp"
    "--disable-music-cmd"
  ];

  preConfigure = ''
    unset CC
    unset CXX
    export SDL_CFLAGS="-I${pspsdk}/psp/include/SDL2"
    export CFLAGS="-I${pspsdk}/psp/include/SDL2"
    export SDL_LIBS="-lSDL2"
    cat acinclude/* >aclocal.m4
    autoconf
    export LDFLAGS="-L${pspsdk}/lib -L${pspsdk}/psp/sdk/lib -L${pspsdk}/psp/lib -lc -lpspuser"
    export LIBS="-lc -lpspuser"
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
