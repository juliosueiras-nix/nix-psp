{ src, stdenv, fetchFromGitHub, pspsdk, bison, ... }:

stdenv.mkDerivation {
  name = "libbulletml";
  inherit src;

  buildInputs = [ pspsdk bison ];

  PSPDIR_OUT = "$(out)/psp";

  patchPhase = ''
    mkdir -p $out/psp/{lib,include}
    substituteInPlace  Makefile --replace '$(PSPDIR)' '$(PSPDIR_OUT)' 
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
