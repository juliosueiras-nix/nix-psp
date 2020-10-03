{ stdenv, autoconf, gcc, libtool, fetchFromGitHub, pspsdk, ... }:

let SDL2_VERSION = "2.0.9";
in stdenv.mkDerivation {
  name = "SDL2";

  src = fetchFromGitHub {
    repo = "SDL2";
    owner = "joel16";
    rev = SDL2_VERSION;
    sha256 = "9Ktm1VBYxfUajW0AkFug5Do4q65AGdo5CBOiomzF6BA=";
  };

  buildInputs = [ pspsdk ];

  dontConfigure = true;

  buildPhase = ''
    sed -i 's;INCDIR = ./include;INCDIR = ./include ${pspsdk}/psp/include;g' Makefile.main.psp Makefile.psp
    mkdir -p $out/psp/include/SDL2
    mkdir -p $out/psp/lib
    make -f Makefile.psp
    make -f Makefile.main.psp
  '';

  installPhase = ''
    cp -v include/*.h $out/psp/include/SDL2
    cp -v libSDL2.a $out/psp/lib
    cp -v libSDL2main.a $out/psp/lib
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}

