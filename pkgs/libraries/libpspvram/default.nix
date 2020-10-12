{ src, stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "libpspvram";
  inherit src;

  buildInputs = [ pspsdk ];

  patchPhase = ''
    mkdir -p $out/psp/{lib,include}
    find . -name Makefile -exec sed -i "s;PSPDIR=\$\(.*\);PSPDIR=$out/psp;g" {} \; 
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
