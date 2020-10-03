{ stdenv, fetchurl, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "smpeg-psp";

  src = fetchFromGitHub {
    owner = "fungos";
    repo = "smpeg-psp";
    rev = "bee77b1c97b9ce437f1c4a5ba644244ab2a2c433";
    sha256 = "X2MPUYWWqt4rVZkFbHq8xUg74EnAqsGO+mhWeWBJYGo=";
  };

  buildInputs = [ pspsdk ];

  patches = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/smpeg-psp.patch";
      sha256 = "fnaEiC3WbP+KnY9+Fe0v9YWhtfa6vAaeJqeYGuqzTqo=";
    })
  ];

  preConfigure = ''
    unset CC
    unset CXX
    export GLOBAL_CFLAGS="-I${pspsdk}/psp/include"
    mkdir -p $out/psp/{lib,include}
  '';

  postPatch = ''
    substituteInPlace Makefile --replace '`psp-config --pspdev-path`' "$out"
    sed -i -e "s/static __inline__ Uint16 SDL_Swap16(Uint16 x)/static __inline__ Uint16 Disable_SDL_Swap16(Uint16 x)/" audio/*.cpp
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
