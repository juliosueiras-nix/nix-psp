{ stdenv, autoconf, automake, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "SDL_mixer";

  src = fetchFromGitHub {
    repo = "SDL_mixer";
    owner = "pspdev";
    rev = "SDL_mixer-psp";
    sha256 = "CzmExrvxBWgz8lh7Tv/rGa0wZh3b2IdL0BvbI7P9aBE=";
  };

  buildInputs = [ autoconf automake pspsdk ];

  configureFlags = [
    "--prefix=$(out)/psp"
    "--host=psp"
    "--with-sdl-prefix=${pspsdk}/psp"
    "--disable-music-cmd"
    "--disable-music-mp3"
  ];

  preConfigure = ''
    unset CC
    unset CXX
    cat acinclude/* >aclocal.m4
    autoconf
    export LDFLAGS="-L${pspsdk}/lib -L${pspsdk}/psp/sdk/lib -L${pspsdk}/psp/lib -lc -lpspuser"
    export LIBS="-lc -lpspuser"
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
