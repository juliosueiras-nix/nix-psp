{ src, stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "jpeg";
  inherit src;

  buildInputs = [ pspsdk ];

  PSPDIR_OUT = "$(out)/psp";

  dontConfigure = true;

  patchPhase = ''
    mkdir -p $out/psp/{include,lib}
    find . -name Makefile -exec sed -i 's/\(.*\)$(PSPDIR)\(.*\)/\1$(PSPDIR_OUT)\2/g' {} \;
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
