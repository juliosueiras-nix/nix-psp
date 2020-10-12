{ src, stdenv, lib, which, pspsdk, binutils, texinfo4, fetchFromGitHub, file, ... }:

stdenv.mkDerivation {
  name = "ebootsigner";

  inherit src;

  buildInputs = [ pspsdk ];

  patchPhase = ''
    mkdir -p $out/bin
    sed -i "s|\$(shell psp-config --pspdev-path)/bin|$out/bin/ebootsigner|g" Makefile
  '';

  dontDisableStatic = true;
}
