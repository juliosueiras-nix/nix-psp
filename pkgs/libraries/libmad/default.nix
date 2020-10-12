{ src, stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "libmad";
  inherit src;

  buildInputs = [ pspsdk ];

  PSPDIR_OUT = "$(out)/psp";

  patchPhase = ''
    mkdir -p $out/psp/{lib,include}
    substituteInPlace src/Makefile --replace '$(PSPDIR)' '$(PSPDIR_OUT)' 
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
