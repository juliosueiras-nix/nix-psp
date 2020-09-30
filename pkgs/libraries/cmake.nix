{ stdenv, runCommand, fetchurl, ... }:

let

  CreatePBP = fetchurl {
    url = "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/CreatePBP.cmake";
    sha256 = "VHmbwT8MfrrOtBkS5g6FB3PuUKfwXfTV3xB8xyV0b4Q=";
  };

  PSP = fetchurl {
    url = "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/PSP.cmake";
    sha256 = "wp7Yyp0KrYRwsKbEVV4Xpk5JEOir9ITFmXcImW65hLc=";
  };

  psp-cmake = fetchurl {
    url = "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/psp-cmake";
    sha256 = "CfbAfkbeYcgwaiaD2cVUKPC8s3etCDYDvZPranjNKls=";
  };
in stdenv.mkDerivation {
  name = "psp-cmake";
  src = null;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/psp/share/cmake
    mkdir -p $out/psp/bin

    cp ${psp-cmake} $out/psp/bin/psp-cmake
    chmod +x $out/psp/bin/psp-cmake

    cp ${CreatePBP} $out/psp/share/cmake/CreatePBP.cmake
    cp ${PSP} $out/psp/share/cmake/PSP.cmake
  '';
}
