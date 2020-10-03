{ stdenv, lib, fetchurl, pspsdk, ... }:

let SQUIRREL_VERSION = "3.0.7";
in stdenv.mkDerivation {
  name = "squirrel";

  src = fetchurl {
    url = "http://sourceforge.net/projects/squirrel/files/squirrel_${
        lib.replaceChars [ "." ] [ "_" ] SQUIRREL_VERSION
      }_stable.tar.gz";
    sha256 = "x8JUji0tdBFjA0RRGOGX9YWjpea94G/f5mjAWxy0P6I=";
  };

  buildInputs = [ pspsdk ];

  patches = [
    (fetchurl {
      url =
        "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/squirrel-${SQUIRREL_VERSION}.patch";
      sha256 = "Q1cF6rIqRqbZs8Y5pTB7xG8lhMcq85cMQmbIsUhGSoE=";
    })
  ];

  buildPhase = ''
    AR="${pspsdk}/bin/psp-ar" CC="${pspsdk}/bin/psp-gcc" CXX="${pspsdk}/bin/psp-g++" LIBS="-lc -lpspuser" make -C squirrel sq32
    AR="${pspsdk}/bin/psp-ar" CC="${pspsdk}/bin/psp-gcc" CXX="${pspsdk}/bin/psp-g++" LIBS="-lc -lpspuser" make -C sqstdlib sq32
  '';

  installPhase = ''
    mkdir -p $out/psp/{lib,include}
    cp -v lib/*.a $out/psp/lib
    cp -v include/*.h $out/psp/include
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
