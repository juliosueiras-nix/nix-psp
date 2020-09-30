{ stdenv, autoconf, automake, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "SDL_ttf";

  src = fetchFromGitHub {
    repo = "SDL_ttf";
    owner = "pspdev";
    rev = "SDL_ttf-psp";
    sha256 = "BeSYKvyJr167a4nJQtp2B9fkYSYVFTk7gUA7MRXoWs8=";
  };

  buildInputs = [ autoconf automake pspsdk ];

  configureFlags = [
    "--prefix=$(out)/psp"
    "--host=psp"
    "--with-sdl-prefix=${pspsdk}/psp"
    "--with-freetype-prefix=${pspsdk}/psp"
    "--without-x"
  ];

  preConfigure = ''
    unset CC
    unset CXX
    aclocal -I acinclude -I${pspsdk}/psp/share/aclocal
    automake --foreign --include-deps --add-missing --copy
    autoconf
    export LDFLAGS="-L${pspsdk}/lib -L${pspsdk}/psp/sdk/lib -L${pspsdk}/psp/lib -lc -lpspuser"
    export LIBS="-lc -lpspuser"
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
