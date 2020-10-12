{ src, stdenv, runCommand, fetchurl, ... }:

let

  CreatePBP = "${src}/patches/CreatePBP.cmake";
  PSP = "${src}/patches/PSP.cmake";
  psp-cmake = "${src}/patches/psp-cmake";
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
